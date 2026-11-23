# Project 22: S3 Log Archive with Lifecycle

## Goal
Reduce AWS storage costs with an S3 Lifecycle policy that archives and then deletes old application logs.

## Technologies
- Amazon S3
- AWS CLI
- Linux VM
- Git and GitHub

## Resources
| Resource        | Value |
|-----------------|-------|
| AWS Account     | 590507089733 |
| Region          | us-east-1 (N. Virginia) |
| S3 Bucket       | project22-log-archive-590507089733 |
| Log Prefix      | logs/ |
| Lifecycle Rule  | Archive-Old-Logs |
| Rule File       | [lifecycle.json](./lifecycle.json) |
| Sample Logs     | [logs/](./logs/) (`app.log`, `error.log`, `access.log`) |

## Lifecycle Rule
| Setting     | Value |
|-------------|-------|
| Rule ID     | Archive-Old-Logs |
| Status      | Enabled |
| Scope       | Filtered (prefix `logs/`) |
| Transition  | Glacier Flexible Retrieval after 30 days |
| Expiration  | Delete objects after 365 days |

```json
{
  "Rules": [
    {
      "ID": "Archive-Old-Logs",
      "Status": "Enabled",
      "Filter": { "Prefix": "logs/" },
      "Transitions": [
        { "Days": 30, "StorageClass": "GLACIER" }
      ],
      "Expiration": { "Days": 365 }
    }
  ]
}
```

## Implementation
1. Created an S3 bucket in us-east-1.
2. Generated sample application logs (`app.log`, `error.log`, `access.log`).
3. Uploaded the log files to the `logs/` prefix in the bucket.
4. Created the lifecycle configuration in `lifecycle.json`.
5. Set objects to move to Glacier Flexible Retrieval after 30 days.
6. Set objects to be deleted after 365 days.
7. Checked the lifecycle rule with the AWS CLI and the AWS Management Console.

## Commands Used
```bash
BUCKET=project22-log-archive-590507089733

# Create the bucket
aws s3 mb s3://$BUCKET --region us-east-1

# Upload the logs
aws s3 cp logs/ s3://$BUCKET/logs/ --recursive

# Apply the lifecycle rule
aws s3api put-bucket-lifecycle-configuration \
  --bucket $BUCKET \
  --lifecycle-configuration file://lifecycle.json

# Check the lifecycle rule
aws s3api get-bucket-lifecycle-configuration \
  --bucket $BUCKET
```

## Test Evidence

### 1. Logs uploaded to S3
The bucket `project22-log-archive-590507089733` contains the `logs/` folder.

![S3 bucket objects](../outputs%20pics/Project%2022/Screenshot%202026-11-22%20002800.png)

### 2. Lifecycle rule enabled
The **Management** tab shows the `Archive-Old-Logs` rule as **Enabled**,
with a **Filtered** scope and the action **Transition to Glacier Flexible Retrieval**.

![Lifecycle rule](../outputs%20pics/Project%2022/Screenshot%202026-11-22%20002821.png)

## Notes
- S3 Lifecycle rules run asynchronously, about once per day.
- The console shows a default minimum object size of **128 KB** for transitions.
  The sample log files are smaller than this, so they will not move to Glacier.
  They will still be deleted after 365 days.

## Deliverables
- Lifecycle configuration ([lifecycle.json](./lifecycle.json))
- Sample application logs ([logs/](./logs/))
- Screenshots of the lifecycle rule ([outputs pics/Project 22](../outputs%20pics/Project%2022/))

## Outcome
Set up automatic lifecycle management for archived application logs in
`project22-log-archive-590507089733`. Objects under `logs/` move to Glacier Flexible Retrieval
after 30 days and are deleted after 365 days, which lowers long-term storage costs.
