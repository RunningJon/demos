#!/bin/sh
PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $PWD/variables.sh

if [ "$HAWQ_USER" == "" ]; then
	echo "HAWQ username not found in variables.sh!"
	exit 1
else

	count=$(grep "%wheel" /etc/sudoers | awk '{print $1}' | grep -v '#' | wc -l)

	if [ "$count" -eq "0" ]; then
		if [ -z "$1" ]; then
			export EDITOR=$0 && sudo -E visudo
		else
			echo "" >> $1
			echo "# Enabling sudo" >> $1
			echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" >> $1
		fi
	fi

	count=$(groups $HAWQ_USER | grep wheel | wc -l)

	if [ "$count" -eq "0" ]; then
		usermod -aG wheel $HAWQ_USER
	fi
fi
