#/bin/bash
set -e
##################################################################################################################################################
# Parameters
##################################################################################################################################################
ACTION=$1
ACTION_SERVICE=$2
HOSTNAME=$3
AMBARI_USER=$4
AMBARI_PASSWORD=$5

if [ "$ACTION" == "start" ]; then
	CONTEXT="Start"
else 
	if [ "$ACTION" == "stop" ]; then
		CONTEXT="Stop"
	else
		echo "Error: Unable to determine action.  Please use start or stop."
		exit 1
	fi
fi

##################################################################################################################################################
# Functions
##################################################################################################################################################
get_ambari_details()
{
	PGPORT=`ps -ef | grep postgres | grep postmaster | awk -F ' ' ' {print $10} '`
	PGUSER=`ps -ef | grep postgres | grep postmaster | awk -F ' ' ' {print $1} '`
	CLUSTER_NAME=`su -c "psql -d ambari -p $PGPORT -U $PGUSER -t -A -c \"select cluster_name from ambari.clusters where provisioning_state = 'INSTALLED'\"" $PGUSER 2>/dev/null` 
	if [[ "$HOSTNAME" == "" || "$AMBARI_USER" == "" || "$AMBARI_PASSWORD" == "" || "$PGPORT" == "" || "$PGUSER" == "" || "$CLUSTER_NAME" == "" ]]; then
		echo "Error: Unable to determine Amabari configuration!"
		exit 1
	fi
}

get_status()
{
	if [ -z "$1" ]; then
		echo "Error: get_status() requires service name as a variable"
		exit 1
	fi

	local SERVICE=$1
	
	curl -s -u $AMBARI_USER:$AMBARI_PASSWORD -X GET http://$HOSTNAME:8080/api/v1/clusters/$CLUSTER_NAME/services/$SERVICE | grep state | grep -v maintenance_state | awk -F ' ' ' {print $3 }' | tr -d "\""
}

start_ambari()
{
	# Ambari status is either "running" or "not running"
	local AMBARI_NOT_RUNNING=`ambari-server status | grep "not running" | grep -v grep | wc -l`

	if [ "$AMBARI_NOT_RUNNING" -eq "1" ]; then
		ambari-server start
	fi

	get_ambari_details

	local SERVICE=HDFS
	local SERVICE_STATUS=$(get_status $SERVICE)

	if [ "$SERVICE_STATUS" == "UNKNOWN" ]; then
		echo -ne "Starting Ambari"
		while [ "$SERVICE_STATUS" == "UNKNOWN" ]; do
			echo -ne "."
			sleep 5
			SERVICE_STATUS=$(get_status $SERVICE)
		done
		echo -ne "done"
		echo ""
	fi
}

start_service()
{
	if [ -z "$1" ]; then
		echo "Error: start_service() requires service name as a variable"
		exit 1
	fi

	local SERVICE=$1
	local SERVICE_STATUS=$(get_status $SERVICE)

	if [ "$SERVICE_STATUS" == "STARTED" ]; then
		echo "$SERVICE already started"
	else
		curl -s -u $AMBARI_USER:$AMBARI_PASSWORD -i -H "X-Requested-By: ambari" -X PUT -d "{\"RequestInfo\": {\"context\" :\"Start $SERVICE via REST\"}, \"Body\": {\"ServiceInfo\": {\"state\": \"STARTED\"}}}" http://$HOSTNAME:8080/api/v1/clusters/$CLUSTER_NAME/services/$SERVICE 2>&1 > /dev/null
		echo -ne "Starting $SERVICE"
		while [ "$SERVICE_STATUS" != "STARTED" ]; do
			echo -ne "."
			sleep 5
			SERVICE_STATUS=$(get_status $SERVICE)
		done
		echo -ne "done"
		echo ""
	fi
}

stop_service()
{
	if [ -z "$1" ]; then
		echo "Error: stop_service() requires service name as a variable"
		exit 1
	fi

	local SERVICE=$1
	local SERVICE_STATUS=$(get_status $SERVICE)

	if [ "$SERVICE_STATUS" == "STARTED" ]; then	
		curl -s -u $AMBARI_USER:$AMBARI_PASSWORD -i -H "X-Requested-By: ambari" -X PUT -d "{\"RequestInfo\": {\"context\" :\"Stop $SERVICE via REST\"}, \"Body\": {\"ServiceInfo\": {\"state\": \"INSTALLED\"}}}" http://$HOSTNAME:8080/api/v1/clusters/$CLUSTER_NAME/services/$SERVICE 2>&1 > /dev/null
		echo -ne "Stopping $SERVICE"
		while [ "$SERVICE_STATUS" != "INSTALLED" ]; do
			echo -ne "."
			sleep 5
			SERVICE_STATUS=$(get_status $SERVICE)
		done
		echo -ne "done"
		echo ""
	else
		echo "$SERVICE already stopped"
	fi
}

##################################################################################################################################################
# Body
##################################################################################################################################################

start_ambari

if [ "$CONTEXT" == "Start" ]; then
	start_service $ACTION_SERVICE
else
	stop_service $ACTION_SERVICE
fi
exit

