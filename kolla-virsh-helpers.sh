#!/bin/bash

vms=/home/pbourke/VMs
kickstart=basekickstart-13Sept2018
token=$2

hosts=(
      operator-$token
      control01-$token
      control02-$token
      control03-$token
      database01-$token
      database02-$token
      network01-$token
      network02-$token
      compute01-$token
      compute02-$token
      storage01-$token
      storage02-$token
      storage03-$token
      myregistry
      )

function destroy-env {
  for i in ${hosts[@]}; do
      virsh undefine ${i}
      virsh destroy ${i}
      rm $vms/${i}.qcow2
  done
}

function mk-env {
  for i in ${hosts[@]}; do
    virt-clone \
        --original ${kickstart} \
        --name ${i} \
        -f $vms/${i}.qcow2 \
        --auto-clone

    virt-edit \
        -d ${i} \
        /etc/hostname -e "s/^.*/$i/"

    virt-edit \
        -d ${i} \
        /etc/sysconfig/network-scripts/ifcfg-eth0 \
        -e 's/^DHCP_HOSTNAME=.*/DHCP_HOSTNAME="'${i}'"/'

    virsh start ${i}
  done
}

function start-env {
  for i in ${hosts[@]}; do
    virsh start ${i}
  done
}

function stop-env {
  for i in ${hosts[@]}; do
    virsh shutdown ${i}
  done
}

$1 $2
