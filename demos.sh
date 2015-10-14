#!/bin/bash
set -e
IFS=","

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

##################################################################################################################################################
# Functions
##################################################################################################################################################
check_variables()
{
	### Make sure variables file is available
	if [ ! -f "$PWD/variables.sh" ]; then
		touch $PWD/variables.sh
	fi

	local count=`grep "REPO=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "REPO=\"demos\"" >> variables.sh
	fi 
	local count=`grep "REPO_URL=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "REPO_URL=\"https://github.com/pivotalguru/demos\"" >> variables.sh
	fi 
	local count=`grep "DATA_DIR=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "DATA_DIR=\"data\"" >> variables.sh
	fi 
	local count=`grep "HAWQ_USER=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "HAWQ_USER=\"gpadmin\"" >> variables.sh
	fi 
	local count=`grep "HDFS_USER=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "HDFS_USER=\"hdfs\"" >> variables.sh
	fi 
	local count=`grep "DEMO_DIR=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "DEMO_DIR=\"demos\"" >> variables.sh
	fi 
	local count=`grep "HOSTNAME=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "HOSTNAME=\"`hostname`\"" >> variables.sh
	fi 
	local count=`grep "AMBARI_USER=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "AMBARI_USER=\"admin\"" >> variables.sh
	fi 
	local count=`grep "AMBARI_PASSWORD=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "AMBARI_PASSWORD=\"admin\"" >> variables.sh
	fi 
	local count=`grep "GPFDIST_PORT=" variables.sh | wc -l`
	if [ "$count" -eq "0" ]; then
		echo "GPFDIST_PORT=\"8000\"" >> variables.sh
	fi 

	echo "############################################################################"
	echo "Sourcing variables.sh"
	echo "############################################################################"
	echo ""
	source variables.sh
}

check_user()
{
	### Make sure root is executing the script. ###
	echo "############################################################################"
	echo "Make sure root is executing this script."
	echo "############################################################################"
	echo ""
	local WHOAMI=`whoami`
	if [ "$WHOAMI" != "root" ]; then
		echo "Script must be executed as root!"
		exit 1
	fi
}

yum_installs()
{
	### Install and Update Demos ###
	echo "############################################################################"
	echo "Install git and curl with yum."
	echo "############################################################################"
	echo ""
	# Install git and curl if not found
	local CURL_INSTALLED=`yum -C list installed curl | grep curl | wc -l`
	local GIT_INSTALLED=`yum -C list installed git | grep git | wc -l`

	if [ "$CURL_INSTALLED" -eq "0" ]; then
		yum -y install curl
	else
		echo "curl already installed"
	fi

	if [ "$GIT_INSTALLED" -eq "0" ]; then
		yum -y install git
	else
		echo "git already installed"
	fi
	echo ""
}

repo_init()
{
	### Install repo ###
	echo "############################################################################"
	echo "Install the github repository with demos."
	echo "############################################################################"
	echo ""
	if [ ! -d /$DATA_DIR ]; then
		echo ""
		echo "Creating data dir"
		echo "-------------------------------------------------------------------------"
		mkdir /$DATA_DIR
		chown $HAWQ_USER /$DATA_DIR	
	fi

	if [ ! -d /$DATA_DIR/$REPO ]; then
		echo ""
		echo "Creating $REPO directory"
		echo "-------------------------------------------------------------------------"
		mkdir /$DATA_DIR/$REPO
		chown $HAWQ_USER /$DATA_DIR/$REPO
		su -c "cd /$DATA_DIR; git clone --depth=1 $REPO_URL" $HAWQ_USER
	else
		git config --global user.email "$HAWQ_USER@$HOSTNAME"
		git config --global user.name "$HAWQ_USER"
		su -c "cd /$DATA_DIR/$REPO; git fetch --all; git reset --hard origin/master" $HAWQ_USER
	fi
}

hadoop_init()
{
	### Create Hadoop directories needed for demos. ###
	echo "############################################################################"
	echo "Create Hadoop directories needed for demos."
	echo "############################################################################"
	echo ""

	if hadoop fs -test -d /user/$HAWQ_USER; then
		echo "/user/$HAWQ_USER exists in Hadoop"
	else
		echo "/user/$HAWQ_USER does not exist in Hadoop"
		echo "Create /user/$HAWQ_USER directory in Hadoop"
		su -c "hdfs dfs -mkdir /user/$HAWQ_USER" $HDFS_USER

		echo "Chown /user/$HAWQ_USER directory in Hadoop to $HAWQ_USER"
		su -c "hdfs dfs -chown $HAWQ_USER /user/$HAWQ_USER" $HDFS_USER
	fi

}

demo_script_check()
{
	### Make sure the repo doesn't have a newer version of this script. ###
	echo "############################################################################"
	echo "Make sure this script is up to date."
	echo "############################################################################"
	echo ""
	# Must be executed after the repo has been pulled
	local d=`diff $PWD/demos.sh /$DATA_DIR/$DEMO_DIR/demos.sh | wc -l`

	if [ "$d" -eq "0" ]; then
		echo "demo.sh script is up to date so continuing to demo."
	else
		echo "demo.sh script is NOT up to date."
		echo ""
		cp /$DATA_DIR/$DEMO_DIR/demos.sh $PWD/demos.sh
		echo "After this script completes, restart the demo.sh with this command:"
		echo "./demos.sh"
		exit 1
	fi

}

phd_shutdown()
{
	local SHUTDOWN=""
	local MENU_CHOICE=""
	while [ -z "$SHUTDOWN" ]; do
		echo ""
		echo "############################################################################"
		echo "Exiting."
		echo "############################################################################"
		echo "Do you also wish to shutdown the Pivotal HD Cluster?"
		echo ""
		local MENU_LIST=("Exit with Shutdown,Exit without Shutdown")
		
		select MENU_CHOICE in $MENU_LIST; do
			break
		done

		if [ "$MENU_CHOICE" == "Exit with Shutdown" ]; then
			echo "Exiting with Shutdown..."
			echo ""
			SHUTDOWN="yes"
			break
		elif [ "$MENU_CHOICE" == "Exit without Shutdown" ]; then
			echo "Exiting without Shutdown..."
			echo ""
			SHUTDOWN="no"
			break
		else
			MENU_CHOICE=""
			SHUTDOWN=""
			echo "Please enter a valid number."
		fi
	done

	if [ "$SHUTDOWN" == "yes" ]; then
		local STOP_SERVICE=""
		local SERVICES="NAGIOS,GANGLIA,KNOX,OOZIE,HIVE,HBASE,ZOOKEEPER,MAPREDUCE2,YARN,PXF,HAWQ,HDFS"
		for STOP_SERVICE in $SERVICES; do
			/$DATA_DIR/$DEMO_DIR/phd3.sh "stop" $STOP_SERVICE "$HOSTNAME" "$AMBARI_USER" "$AMBARI_PASSWORD"
		done
	fi
	echo ""
}

exists() 
{
	for i in $2; do
		if [ $2 == i ]; then
			echo "1"
		fi
	done
}

check_sudo()
{
	cp /$DATA_DIR/$DEMO_DIR/update_sudo.sh $PWD/update_sudo.sh
	$PWD/update_sudo.sh
}

##################################################################################################################################################
# Body
##################################################################################################################################################

check_user
check_variables
yum_installs
repo_init
demo_script_check
check_sudo

CONTINUE=""
while [ -z "$CONTINUE" ]; do
	MYDEMO=""
	while [ -z $MYDEMO ]; do
		clear
		echo "Type the number that corresponds to the demo you would like to see..."
		DEMO_LIST=$(cat /$DATA_DIR/$REPO/demos.txt | awk -F '|' '{print $1}' | awk '{printf ("%s,", $0)}')
		DEMO_LIST=$(echo "$DEMO_LIST"Exit)

		select MYDEMO in $DEMO_LIST; do
			break
		done

		if $(exists $MYDEMO $DEMO_LIST); then
			echo "Choice: $MYDEMO"
		else
			MYDEMO=""
			echo "Please enter a valid number that corresponds to the demo you wish to see."
			echo ""
		fi
		if [ "$MYDEMO" == "Exit" ]; then
			echo "Exiting..."
			break
		fi
	done

	if [ "$MYDEMO" == "Exit" ]; then
		break
	else
		### Start PHD Services for this Demo ###
		START_SERVICE=""
		SERVICES=`grep $MYDEMO /$DATA_DIR/$REPO/demos.txt | awk -F '|' '{print $2}' | awk '{printf ("%s,", $0)}'`

		for START_SERVICE in $SERVICES; do
			/$DATA_DIR/$DEMO_DIR/phd3.sh "start" "$START_SERVICE" "$HOSTNAME" "$AMBARI_USER" "$AMBARI_PASSWORD"
		done

		hadoop_init

		### Execute the demo ###
		su --session-command="cd \"/$DATA_DIR/$REPO/$MYDEMO\"; ./rollout.sh \"$DATA_DIR\" \"$DEMO_DIR\" \"$GPFDIST_PORT\"" $HAWQ_USER

		echo ""
		echo "Demo \"$MYDEMO\" is complete."
	fi

	read -p "Hit enter to continue..."
done

phd_shutdown
