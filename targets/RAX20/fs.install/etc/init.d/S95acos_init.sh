#!/bin/sh
echo "Acos service start!"


#
#/sbin/read_bd
# run acos init once
#/sbin/acos_init_once
# run acos init -- to init default platform setup.
# should run after all nvram is ready.
# may need move to smd or other place
/sbin/acos_init
acos_service start 
