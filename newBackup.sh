#!/bin/bash

BACKUPUUID="2d2b7382-3d33-4242-8cd6-77e4617c8d52"


devname=$(blkid -U $BACKUPUUID)
if [[ $devname != "" ]]
then
  echo "Chiavetta di backup su $devname"
else
  echo "Inserisci la chiavetta di backup e ripeti il comando"
  exit
fi

if df | grep -q "$devname"
then
  mountpoint=$(findmnt -no TARGET $devname)
  echo "...montata sulla directory $mountpoint"
  if [ -w $mountpoint ]
  then
    cd
    backupdir="$mountpoint/backup_$(date +%Y%m%d-%H%M%S)"
    rsync -av --delete --backup-dir=$backupdir --no-specials --no-devices . --exclude={backup_*,.cache,noBackup,Dropbox} $mountpoint
  else
    echo "Non posso scrivere sulla chiavetta: estraila, reinseriscila e ripeti il comando"
    exit
  fi
else 
  echo "Chiavetta non montata: estraila, reinseriscila e ripeti il comando"
  exit
fi
