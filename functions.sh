#!/bin/bash
#FUNCTIONS
set -e

source_bashrc()
{
	echo "############################################################################"
	echo "Source .bashrc"
	echo "############################################################################"
	source ~/.bashrc
	echo ""
}

set_psqlrc()
{
	echo "############################################################################"
	echo "Set the .psqlrc file"
	echo "############################################################################"
	echo "\timing" > ~/.psqlrc
	echo ""
}

start_gpfdist()
{
	echo "############################################################################"
	echo "Start gpfdist process"
	echo "############################################################################"
	local count=`ps -ef | grep gpfdist | grep $GPFDIST_PORT | grep -v grep | wc -l`
	if [ "$count" -eq "1" ]; then
		gpfdist_pid=`ps -ef | grep gpfdist | grep $GPFDIST_PORT | grep -v grep | awk -F ' ' '{print $2}'`
		if [ "$gpfdist_pid" != "" ]; then
			echo "Stopping gpfdist on pid: $gpfdist_pid"
			kill $gpfdist_pid
			sleep 2
		fi
	fi
	echo "Starting gpfdist port $GPFDIST_PORT"
	echo "gpfdist -d /$DATA_DIR/$DEMO_DIR/data -p $GPFDIST_PORT >> /dev/null 2>&1 < /dev/null &"
	gpfdist -d /$DATA_DIR/$DEMO_DIR/data -p $GPFDIST_PORT >> /dev/null 2>&1 < /dev/null &
	gpfdist_pid=$!

	# check gpfdist process was started
	if [ "$gpfdist_pid" -ne "0" ]; then
		sleep 0.4
		count=`ps -ef 2> /dev/null | grep -v grep | awk -F ' ' '{print $2}' | grep $gpfdist_pid | wc -l`
		if [ "$count" -eq "1" ]; then
			echo "gpfdist started on port $GPFDIST_PORT"
		else
			echo "ERROR: gpfdist couldn't start on port $GPFDIST_PORT"
			exit 1
		fi
	fi
	echo ""
}

stop_gpfdist()
{
	echo "############################################################################"
	echo "Stop gpfdist process"
	echo "############################################################################"
	if [ "$gpfdist_pid" != "" ]; then
		echo "Stopping gpfdist on pid: $gpfdist_pid"
		kill $gpfdist_pid
	fi
	echo ""
}

log()
{
	#duration
	T="$(($(date +%s%N)-T))"

	id=`echo $i | awk -F '.' ' { print $1 } '`

	# seconds
	S="$((T/1000000000))"
	# milliseconds
	M="$((T/1000000))"

	printf "$id|$table_name|%02d:%02d:%02d.%03d\n" "$((S/3600%24))" "$((S/60%60))" "$((S%60))" "${M}" >> rollout.log
	
}

create_reports_schema()
{
	echo "############################################################################"
	echo "Create reporting schema for later analysis of HAWQ"
	echo "############################################################################"
	local MY_DIR=$1
	local schema_count=`psql -A -t -c "SELECT count(*) from pg_namespace WHERE nspname = 'reports'"`
	if [ "$schema_count" -eq "0" ]; then
		psql -c "CREATE SCHEMA reports;"
	fi

	local table_count=`psql -A -t -c "SELECT count(*) from pg_namespace n JOIN pg_class c ON c.relnamespace = n.oid  WHERE n.nspname = 'reports' AND c.relname = '$DEMO' AND relstorage = 'x'"`
	if [ "$table_count" -eq "0" ]; then
		psql -c "CREATE EXTERNAL WEB TABLE reports.$DEMO (id int, table_name varchar, duration time) EXECUTE 'cat \"$MY_DIR/rollout.log\"' ON MASTER FORMAT 'TEXT' (DELIMITER '|');"
	fi
	echo ""
}

remove_old_log()
{
	echo "############################################################################"
	echo "Remove old logs"
	echo "############################################################################"
	local MY_DIR=$1
	echo "rm -f \"$MY_DIR/rollout.log\""
	rm -f "$MY_DIR/rollout.log"
	echo ""
}

hadoop_init()
{
	echo "############################################################################"
	echo "Init Hadoop"
	echo "############################################################################"
	local MY_DIR=$1
	sudo -u hdfs hdfs dfs -rm -f -r -skipTrash "$MY_DIR"
	echo ""
}
