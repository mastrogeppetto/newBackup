#!/bin/bash
set -e
set -x

# Cambia questa con la UUID delle chiavetta di backup
# Trova l'uuid con "lsblk -f"
BACKUPUUID="2d2b7382-3d33-4242-8cd6-77e4617c8d52"
# Lascia stare il resto
EXCLUDE="$HOME/exclude_patterns.txt"

dryrun=""

while getopts "nb:" opt; do
  case $opt in
    n)
      echo "Opzione -n: dry-run, verifico senza eseguire"
      dryrun="--dry-run"
      ;;
    b)
      echo "Opzione -b specificata con valore: $OPTARG"
      ;;
    *)
      echo "Opzione non valida"
      ;;
  esac
done
shift $((OPTIND-1))

SOURCEDIR=$HOME/

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
    backupdir="$mountpoint/backup_$(date +%Y%m%d-%H%M%S)"
    mkdir -p $mountpoint/$backupdir
    rsync -av \
		--info=stats2 \
		--delete \
		--backup-dir=$backupdir \
		--no-specials \
		--no-devices \
		--exclude-from=$EXCLUDE \
		$dryrun \
		$SOURCEDIR \
		$mountpoint
  else
    echo "Non posso scrivere sulla chiavetta: estraila, reinseriscila e ripeti il comando"
    exit
  fi
else 
  echo "Chiavetta non montata: estraila, reinseriscila e ripeti il comando"
  exit
fi
