#!/bin/bash

#BACKUPUUID="2d2b7382-3d33-4242-8cd6-77e4617c8d52"
BACKUPUUID="4609ae3c-82a8-4185-bc95-20479f714187"
SOURCEDIR=$HOME
DESTDIR=$USER

while getopts ":n" option; do
   case $option in
      n) dryrun="--dry-run"
         ;;
   esac
done

if [ "$EUID" -eq 0 ]
  then echo "Non usare con sudo!"
  exit
fi

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
    mkdir -p $mountpoint/$DESTDIR
    backupdir="$mountpoint/$DESTDIR-$(date +%Y%m%d-%H%M%S)"
    rsync -av \
    	  --delete \
    	  --backup-dir=$backupdir \
    	  --no-specials \
    	  --no-devices \
    	  --exclude={backup_*,noBackup,Dropbox,.dropbox,.docker,.cache} \
    	  $dryrun \
    	  $SOURCEDIR/ \
    	  $mountpoint/$DESTDIR
  else
    echo "Non posso scrivere sulla chiavetta: estraila, reinseriscila e ripeti il comando"
    exit
  fi
else 
  echo "Chiavetta non montata: estraila, reinseriscila e ripeti il comando"
  exit
fi
