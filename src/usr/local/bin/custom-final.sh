#!/bin/bash

# this should be fixed by the new version of initscripts RPM
BOOTDEV=br1
BOOTIP=$(ip addr show dev ${BOOTDEV} scope global |grep inet|awk '{print $2}')
ip addr change ${BOOTIP} dev ${BOOTDEV} valid_lft forever preferred_lft forever
#/usr/local/bin/ramcloud.sh
