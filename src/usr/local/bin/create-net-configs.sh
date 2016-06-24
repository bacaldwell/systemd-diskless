#!/bin/bash

set -e

die() { echo "$@" 1>&2 ; exit 1; }

IP=$(route -n|awk '$1 == "0.0.0.0" {print $8}'| xargs ip addr show dev|grep inet|sed 's/.*inet \(.*\)\/.*/\1/')
#NAME=${HOSTNAME%%.*}
NAME=$(awk "\$1 == \"$IP\" {print \$NF}" /etc/hosts)
echo "creating network configs for $NAME"

MAPS="/etc/diskless/ib.map
/etc/diskless/br.map"

CONFIGURED=
for MAP in $MAPS; do
  for LINE in $(awk -F":" "\$1 == \"$NAME\" { print }" $MAP); do
    DEVICE=$(echo $LINE|awk -F":" '{ print $2 }')
    IP=$(echo $LINE|awk -F":" '{ print $3 }')
    TEMPLATE=$(echo $LINE|awk -F":" '{ print $4 }')
    echo Activating interface $DEVICE with $IP
    sed -e "s/%%IP_ADDR%%/$IP/" -e "s/%%DEVICE%%/$DEVICE/" \
      /etc/sysconfig/network-scripts/$TEMPLATE > \
      /etc/sysconfig/network-scripts/ifcfg-${DEVICE}
    #bash -c "ifup ${DEVICE}; exit 0"
    #echo connected > /sys/class/net/ib0/mode
    CONFIGURED=1
  done
done

[[ $CONFIGURED ]] || die "no interfaces configured for $NAME"
