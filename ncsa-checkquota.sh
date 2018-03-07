#!/bin/bash

source /var/mmfs/etc/gpfs_functions

CMDOPTS='-N coreio'

# Check to see if we are runing on the cluster manager.  If not, quit.
if ! is_node_gpfs_manager ; then
   exit
fi

MMCHECKQUOTA=`which mmcheckquota 2>/dev/null`
if [ "x${MMCHECKQUOTA}" == "x" ] ; then
   echo "GPFS Not Installed..."
   exit 1
fi

# Scan for multiple GPFS file systems.
for gpfsdev in `mount -t gpfs | awk '{print($1)}' | sed -e 's/\/dev\///g'`
    do LOGFILE=/tmp/quotacheck.${gpfsdev}
    if are_quotas_enabled $gpfsdev ; then
       date > ${LOGFILE}
       echo "Executing: ${MMCHECKQUOTA}  ${CMDOPTS} ${gpfsdev} &>>${LOGFILE}" >> ${LOGFILE}
       ${MMCHECKQUOTA}  ${CMDOPTS} ${gpfsdev} &>>${LOGFILE}
       RC=$?
       echo "Return Code: ${RC}" >>${LOGFILE}
       date >> ${LOGFILE}
       if [ ${RC} -ge 1 ] ; then
          cat ${LOGFILE}
       fi
    fi
done

