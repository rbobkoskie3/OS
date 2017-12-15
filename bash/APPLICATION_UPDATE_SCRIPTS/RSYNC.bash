rsync -avz 10.5.0.217:/mnt/rpta/flood-db/ /mnt/rpta/flood-db >~rb868x/RSYNC_rpta_flood-db.log 2>/dev/null&

# rsync -avzu /var/flood 10.5.0.217:/var |tee ~rb868x/var.log
# rsync -avzu /etc/ssh/ 10.5.0.217:/etc/ssh |tee ~rb868x/rsync-etc-ssh.log
# rsync -avzu /usr/local/etc/ 10.5.0.217:/usr/local/etc |tee ~rb868x/rsync-usr-etc-ssh.log

# rsync -avzu /mnt/rpta/data/ 10.5.0.217:/mnt/rpta/data |tee ~rb868x/data.log
# rsync -avzu /mnt/rpta/db/flooddb/data/ 10.5.0.217:/flood-db/data |tee ~rb868x/rsync-floodDB-data.log
# rsync -avzu /mnt/rpta/db/flooddb/indices/ 10.5.0.217:/flood-db/indices |tee ~rb868x/rsync-floodDB-indices.log
# rsync -avzu /mnt/rpta/db/flooddb/processing/ 10.5.0.217:/flood-db/processing |tee ~rb868x/rsync-floodDB-processing.log
