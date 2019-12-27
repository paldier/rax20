#!/bin/sh

case "$1" in
	start)
		echo "Starting CMS smd..."
		echo "Starting CMS smd..." > /tmp/wlssk_finished
		/bin/smd
		exit 0
		;;

	stop)
		echo "Stopping CMS smd..."
		/bin/send_cms_msg -r 0x1000080D 20
		exit 0
		;;

	*)
		echo "$0: unrecognized option $1"
		exit 1
		;;

esac

