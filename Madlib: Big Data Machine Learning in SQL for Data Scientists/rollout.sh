#!/bin/bash
set -e
source ../functions.sh
DEMO=madlib
HOSTNAME=`hostname`
DATA_DIR=$1
DEMO_DIR=$2
GPFDIST_PORT=$3

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo ""
echo "############################################################################"
echo "Demo Configuration"
echo "############################################################################"
echo "DATA_DIR: $DATA_DIR"
echo "DEMO_DIR: $DEMO_DIR"

if [ "$GPFDIST_PORT" == "" ]; then
	echo "Error: Unable to determine parameters for this script!"
	exit 1
fi

echo ""
echo "############################################################################"
echo "This is a demonstration of the Madlib Linear Regression capability that"
echo "predicts housing prices based on 4 different input variables."
echo ""
echo "Madlib is an open source project sponsored by Pivotal with the goal to"
echo "provide Big Data Machine Learning with SQL."
echo ""
echo "Check out the full list of functions on http://madlib.net"
echo ""
echo "Steps:"
echo "1. Build table with variables used to generate random data within specific"
echo "   ranges"
echo "2. Build table with housing data"
echo "3. Perform linear regression across the entire data set"
echo "4. Perform linear regression with a model per \"bedroom\" value"
echo "5. Show results of models"
echo "6. Show predicted values based on models"
echo "############################################################################"
echo ""
read -p "Hit enter to continue..."
echo ""
source_bashrc
set_psqlrc
remove_old_log "$PWD"

echo "############################################################################"
echo "HAWQ Begin"
echo "############################################################################"
#HAWQ Tables
for i in $( ls *.hawq.sql ); do
	id=`echo $i | awk -F '.' ' { print $1 } '`
	schema_name=`echo $i | awk -F '.' ' { print $2 } '`
	table_name=`echo $i | awk -F '.' ' { print $2 "." $3 } '`
	echo $i
	#begin time
	T="$(date +%s%N)"

	if [ "$schema_name" == "expanded" ]; then
		psql -x -a -P pager=off -f $i -v LOCATION=$LOCATION
	else
		psql -a -P pager=off -f $i -v LOCATION=$LOCATION
	fi
	log
	echo ""
	if [ "$id" != "00" ]; then
		read -p "Hit enter to continue..."
	fi
	clear

done
echo ""
echo "############################################################################"
echo "Completed HAWQ"
echo "############################################################################"
echo ""
echo "############################################################################"
echo "This demo was based on the example of Linear Regression from the Madlib"
echo "site: http://doc.madlib.net/latest/group__grp__linreg.html#examples"
echo ""
echo "Next, explore the scripts from this demo to better understand how this demo"
echo "was implemented:"
echo "$PWD"
echo "############################################################################"
