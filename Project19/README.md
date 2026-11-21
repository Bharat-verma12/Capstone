# Project 19: Scheduled S3 Backup

## Goal
Automate log file backups from a Linux VM to Amazon S3.

## Technologies Used
- AWS S3
- AWS CLI
- Linux VM
- Bash Scripting
- Cron Jobs
- Git and GitHub

## Features
- Automatic log file backup
- Timestamped compressed backup archives
- Scheduled execution using cron
- Backup storage in Amazon S3

## How It Works
1. The Bash script compresses log files.
2. AWS CLI uploads the archive to S3.
3. A cron job runs the script automatically.
4. Backup files are verified in the S3 bucket.

## Cron Schedule
Runs every 5 minutes for testing:

```cron
*/5 * * * * /home/clouduser/Project19/backup.sh >> /home/clouduser/Project19/cron.log 2>&1
```

## Usage
Configure AWS CLI credentials and S3 permissions.

Update BUCKET_NAME in backup.sh with your bucket name.

Run:

```bash
chmod +x backup.sh
./backup.sh
```

## Verify Backups

```bash
aws s3 ls s3://YOUR-BUCKET-NAME/backups/
```
