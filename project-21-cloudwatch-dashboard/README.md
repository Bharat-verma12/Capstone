# Project 21: AWS CloudWatch Monitoring Dashboard

## Goal
Visualize AWS EC2 performance using Amazon CloudWatch.

## AWS Services Used
- Amazon EC2
- Amazon CloudWatch
- AWS CLI

## Metrics Monitored
1. CPU Utilization
2. Network In
3. Network Out
4. Status Check Failed

## Implementation Steps
1. Verified AWS CLI configuration.
2. Identified a running EC2 instance.
3. Verified CloudWatch metrics.
4. Created dashboard.json.
5. Deployed the dashboard using AWS CLI.
6. Verified the dashboard in AWS Console.

## Dashboard Deployment

```bash
aws cloudwatch put-dashboard \
  --dashboard-name Project21-EC2-Monitoring \
  --dashboard-body file://dashboard.json \
  --region us-east-1
```

## Dashboard Screenshot

![CloudWatch Dashboard](screenshots/dashboard.png)

## Result
Successfully created an AWS CloudWatch dashboard
to monitor EC2 performance and health.

