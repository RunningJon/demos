#!/bin/bash
set -e
source ../functions.sh
DEMO=pxf
HOSTNAME=`hostname`

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
WHOAMI=`whoami`
PXF_DATA_DIR=/user/$WHOAMI/sample
NN_PORT=50070

echo ""
echo "############################################################################"
echo "This is a demonstration of Pivotal HAWQ Pivotal Extenstion Frameworkd (PXF)"
echo "Steps:"
echo "1.  Create Function in HAWQ to aid in the generation of random data"
echo "2.  Create External Writable Table in HAWQ to create sample HDFS TEXT file"
echo "3.  Create External Table in HAWQ to read HDFS TEXT file"
echo "4.  Create HAWQ Table stored in Parquet format with Snappy compression with"
echo "the contents of the HDFS TEXT file."
echo "5.  Execute simple Query on the HAWQ External Table"
echo "6.  Execute the same simple Query on the HAWQ Parquet+Snappy table"
echo "7.  Create Hive External Table using HDFS TEXT file"
echo "8.  Create Hive Tables stored in ORC and Parquet formats by selecting"
echo "contents of HDFS TEXT file"
echo "9.  Create HAWQ External Table by reading the Hive ORC Table"
echo "10. Create HAWQ External Table by reading the Hive Parquet Table"
echo "11. Execute same simple Query on the HAWQ External Table which selects from"
echo "the Hive Orc Table" 
echo "12. Execute same simple Query on the HAWQ External Table which selects from"
echo "the Hive Parquet Table" 
echo "############################################################################"
echo ""
read -p "Hit enter to continue..."
echo ""
source_bashrc
set_psqlrc
create_reports_schema "$PWD"
remove_old_log "$PWD"
hadoop_init $PXF_DATA_DIR

# Step 1
for i in $( ls *.step1.sql ); do
	table_name=`echo $i | awk -F '.' ' { print $2 "." $3 } '`
	echo $i
	#begin time
	T="$(date +%s%N)"

	LOCATION="'pxf://$HOSTNAME:$NN_PORT$PXF_DATA_DIR?profile=HdfsTextSimple'"
	psql -a -P pager=off -f $i -v LOCATION=$LOCATION
	echo ""

	log
done
echo ""
# Step 2
for i in $( ls *.step2.sql ); do
	table_name=`echo $i | awk -F '.' ' { print $2 "." $3 } '`
	echo $i
	#begin time
	T="$(date +%s%N)"

	beeline -u jdbc:hive2://$HOSTNAME:10000 -n pxf -f $i
	echo ""

	log
done
echo ""
# Step 3
for i in $( ls *.step3.sql ); do
	table_name=`echo $i | awk -F '.' ' { print $2 "." $3 } '`
	hive_table_name=`echo $i | awk -F '.' ' { print $3 } '`
	echo $i
	#begin time
	T="$(date +%s%N)"

	LOCATION="'pxf://$HOSTNAME:$NN_PORT/$hive_table_name?profile=Hive'"

	psql -a -P pager=off -f $i -v LOCATION=$LOCATION
	echo ""

	log
done
echo ""
# Step 4
for i in $( ls *.step4.sql ); do
	table_name=`echo $i | awk -F '.' ' { print $2 "." $3 } '`
	echo $i
	#begin time
	T="$(date +%s%N)"

	psql -a -P pager=off -f $i 
	echo ""

	log
done
echo ""
echo "############################################################################"
echo "Results"
echo "############################################################################"
echo ""
psql -f report.sql
echo ""
echo "############################################################################"
echo "Additional Hive formats include:"
echo "HiveRC: Use this when connecting to a Hive table where each partition is"
echo "stored as an RCFile"
echo "HiveText: Use this when connecting to a Hive table where each partition is"
echo "stored as a text file."
echo ""
echo "Additional PXF formats include:"
echo "HBase: Works similarly to Hive where it uses the Hbase tables in the"
echo "External Table"
echo "Avro: Reads Avro stored files"
echo "HdfsTextMulti: Reads mult-line files"
echo ""
echo "Explore the scripts from this demo to better understand how HAWQ works:."
echo "$PWD"
echo "############################################################################"
