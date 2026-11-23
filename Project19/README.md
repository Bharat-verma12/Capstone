# Project 19: Scheduled S3 Backup

## Goal
Automatically back up log files from a Linux VM to Amazon S3.

## Technologies Used
- Amazon S3
- AWS CLI v2
- Linux VM (Ubuntu)
- Bash scripting
- Cron jobs
- Git and GitHub

## Resources
| Resource      | Value |
|---------------|-------|
| AWS Account   | 590507089733 |
| Region        | us-east-1 (N. Virginia) |
| S3 Bucket     | project19-s3-backup-2026-uniqueid |
| S3 Prefix     | backups/ |
| Host          | AZLTT0222435e27 (clouduser) |
| Source Folder | ~/Project19/logs |
| Local Backups | ~/Project19/backups |
| Cron Log      | ~/Project19/cron.log |

## Features
- Automatic log file backup
- Compressed backup archives with a timestamp in the name (`logs_YYYY-MM-DD_HH-MM-SS.tar.gz`)
- Scheduled runs using cron
- Backups stored in Amazon S3
- Stops on the first error (`set -euo pipefail`)

## How It Works
1. The Bash script compresses the `logs/` folder into a `.tar.gz` file with a timestamp in its name.
2. The AWS CLI uploads the archive to `s3://<bucket>/backups/`.
3. A cron job runs the script on a schedule.
4. The backup files are checked in the S3 bucket.

## Backup Script
```bash
#!/bin/bash

set -euo pipefail

BUCKET_NAME="project19-s3-backup-2026-uniqueid"
SOURCE_DIR="$HOME/Project19/logs"
BACKUP_DIR="$HOME/Project19/backups"
DATE=$(date +%Y-%m-%d_%H-%M-%S)

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/logs_$DATE.tar.gz"

echo "Starting backup: $(date)"

tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

aws s3 cp "$BACKUP_FILE" \
  "s3://$BUCKET_NAME/backups/"

echo "Backup completed: $(date)"
```

## Cron Schedule
For testing, the job ran every 5 minutes:

```cron
*/5 * * * * /home/clouduser/Project19/backup.sh >> /home/clouduser/Project19/cron.log 2>&1
```

After testing, the schedule was changed to run every day at 02:00 (UTC):

```cron
0 2 * * * /home/clouduser/Project19/backup.sh >> /home/clouduser/Project19/cron.log 2>&1
```

## Usage
1. Set up AWS CLI credentials that have permission to write to the bucket (`s3:PutObject`).
2. Update `BUCKET_NAME` in `backup.sh` with your bucket name.
3. Run:

```bash
chmod +x backup.sh
./backup.sh
```

4. Schedule it:

```bash
crontab -e
crontab -l
```

## Verify Backups
```bash
aws s3 ls s3://project19-s3-backup-2026-uniqueid/backups/
tail -20 ~/Project19/cron.log
```

## Test Evidence

### 1. Setup and manual backup
- Set `BUCKET_NAME` and created sample logs in `~/Project19/logs/app.log`.
- Made `backup.sh` executable (`-rwxrwxr-x`, 422 bytes).
- A manual run uploaded `logs_2026-11-21_07-25-56.tar.gz` to S3.

![Manual backup](../outputs%20pics/Project%2019/Screenshot%202026-11-21%20125611.png)

### 2. Backup in the S3 console
The `backups/` prefix contains `logs_2026-11-21_07-25-56.tar.gz` (215 B, Standard storage class).

![S3 console](../outputs%20pics/Project%2019/Screenshot%202026-11-21%20125709.png)

### 3. Scheduled backup and crontab
`aws s3 ls` shows 2 backups: the manual run (07:25:58) and a cron run (07:30:04).
`crontab -l` shows the daily `0 2 * * *` schedule.

![S3 listing and crontab](../outputs%20pics/Project%2019/Screenshot%202026-11-21%20130157.png)

### 4. Cron log
`cron.log` shows that the scheduled run at 07:30:01 UTC uploaded `logs_2026-11-21_07-30-01.tar.gz`.

![Cron log](../outputs%20pics/Project%2019/Screenshot%202026-11-21%20130254.png)

## Security
`.gitignore` keeps logs, backup archives, `.env` files, and `.aws/` credentials out of Git.

## Result
Set up automatic log backups from a Linux VM to Amazon S3 using a Bash script and cron.
Both the manual run and the scheduled run uploaded compressed archives with timestamps in their names
to `s3://project19-s3-backup-2026-uniqueid/backups/`.
