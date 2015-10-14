#!/bin/bash
set -e
source ../functions.sh
DEMO=cms
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
echo "GPFDIST_PORT: $GPFDIST_PORT"

if [ "$GPFDIST_PORT" == "" ]; then
	echo "Error: Unable to determine parameters for this script!"
	exit 1
fi

echo ""
echo "############################################################################"
echo "This is a demonstration of Pivotal HAWQ loading and querying data stored in"
echo "HDFS using a sample dataset from CMS."
echo "Steps:"
echo "1. Create a \"reports\" schema in HAWQ to capture execution times"
echo "2. Load 10 million claims (486 MB) and small dimension tables into HAWQ"
echo "3. Create a table that is the result of a join of all tables together"
echo "4. Execute 3 basic SELECT statements against the large table"
echo "5. Capture performance metrics for each step with the grand total"
echo ""
echo "############################################################################"
echo ""
read -p "Hit enter to continue..."
echo ""
source_bashrc
set_psqlrc
start_gpfdist
create_reports_schema "$PWD"
remove_old_log "$PWD"

echo "############################################################################"
echo "HAWQ Begin"
echo "############################################################################"
#HAWQ Tables
for i in $( ls *.hawq.sql ); do
	table_name=`echo $i | awk -F '.' ' { print $2 "." $3 } '`
	echo $i
	#begin time
	T="$(date +%s%N)"

	#check to see if there are more than one file for this table
	count=`ls /$DATA_DIR/$DEMO_DIR/data/$table_name.* 2> /dev/null | wc -l`

	if [ "$count" -ge "1" ]; then
		LOCATION="'gpfdist://$HOSTNAME:$GPFDIST_PORT/$table_name.*'"
	else
		LOCATION="'gpfdist://$HOSTNAME:$GPFDIST_PORT/$table_name'"
	fi

	psql -a -P pager=off -f $i -v LOCATION=$LOCATION
	echo ""

	log
done
echo ""
echo "############################################################################"
echo "Completed HAWQ"
echo "############################################################################"
echo ""
stop_gpfdist
echo "############################################################################"
echo "Results"
echo "############################################################################"
echo ""
psql -f report.sql
echo ""
echo "############################################################################"
echo "Explore the scripts from this demo to better understand how HAWQ works:"
echo "$PWD"
echo "############################################################################"
