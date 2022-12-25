#!/bin/sh
####################################
## Backup script.
#####################################
backup_files="/var/khala-pruntime-data"
dest="/home/backup"
day=$(date +%d%m%y)
hostname=$(hostname -s)
archive_file="$hostname-$day.tgz"
echo "Backing up $backup_files to $dest/$archive_file"
date
echo
tar czf $dest/$archive_file $backup_files
echo
echo "Backup finished"
date
ls -lh $dest
find /home/backup/w* -mtime +7 -type f -exec rm -f {} \;
