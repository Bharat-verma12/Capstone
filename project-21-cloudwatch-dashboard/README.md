# Project 21: AWS CloudWatch Monitoring Dashboard

## Goal
Show the performance and health of an AWS EC2 instance on an Amazon CloudWatch dashboard.

## AWS Services Used
- Amazon EC2
- Amazon CloudWatch
- AWS CLI

## Resources
| Resource       | Value |
|----------------|-------|
| AWS Account    | 590507089733 |
| Region         | us-east-1 (N. Virginia) |
| EC2 Instance   | i-06ad9757a3d3f9f67 (t2.micro) |
| Dashboard Name | Project21-EC2-Monitoring |
| Dashboard File | [dashboard.json](./dashboard.json) |

## Metrics Monitored
| Widget                  | Metric            | Statistic | Period |
|-------------------------|-------------------|-----------|--------|
| EC2 CPU Utilization     | CPUUtilization    | Average   | 5 min  |
| EC2 Network In          | NetworkIn         | Sum       | 5 min  |
| EC2 Network Out         | NetworkOut        | Sum       | 5 min  |
| EC2 Status Check Failed | StatusCheckFailed | Maximum   | 5 min  |

## Implementation Steps
1. Checked the AWS CLI configuration.
2. Found a running EC2 instance.
3. Checked which CloudWatch metrics were available for the instance.
4. Created `dashboard.json` with 4 widgets in a 2x2 layout.
5. Deployed the dashboard with the AWS CLI.
6. Checked the dashboard in the AWS Console.

## Commands Used
```bash
# 1. List EC2 instances
aws ec2 describe-instances \
  --region us-east-1 \
  --query 'Reservations[].Instances[].[InstanceId,State.Name,InstanceType]' \
  --output table

# 2. List the CloudWatch metrics available for the instance
INSTANCE_ID=i-06ad9757a3d3f9f67
aws cloudwatch list-metrics \
  --namespace AWS/EC2 \
  --dimensions Name=InstanceId,Value=$INSTANCE_ID \
  --region us-east-1 \
  --query 'Metrics[].MetricName' \
  --output table

# 3. Deploy the dashboard
aws cloudwatch put-dashboard \
  --dashboard-name Project21-EC2-Monitoring \
  --dashboard-body file://dashboard.json \
  --region us-east-1
```

## Test Evidence

### 1. Running EC2 instances
Listed the EC2 instances in us-east-1. Instance `i-06ad9757a3d3f9f67` (t2.micro) was `running`
and was used for this dashboard.

![EC2 instances](../outputs%20pics/Project%2021/Screenshot%202026-11-21%20170900.png)

### 2. Available CloudWatch metrics
The instance publishes metrics including `CPUUtilization`, `NetworkIn`, `NetworkOut`,
`StatusCheckFailed`, CPU credit metrics, and EBS metrics.

![CloudWatch metrics](../outputs%20pics/Project%2021/Screenshot%202026-11-21%20172220.png)

### 3. Dashboard deployed
`put-dashboard` returned an empty `DashboardValidationMessages` list,
so the dashboard body was valid.

![Dashboard deployed](../outputs%20pics/Project%2021/Screenshot%202026-11-21%20172533.png)

### 4. Dashboard in the AWS Console
The `Project21-EC2-Monitoring` dashboard shows all 4 widgets over a 3-hour window:
- **CPU Utilization:** mostly about 1.2%, with one spike to about 5% around 10:08.
- **Network In:** one spike to about 104 MB around 10:08.
- **Network Out:** one spike to about 240 KB around 10:08.
- **Status Check Failed:** stayed at 0, so the instance was healthy.

![CloudWatch Dashboard](../outputs%20pics/Project%2021/Screenshot%202026-11-21%20174255.png)

## Deliverables
- Dashboard definition ([dashboard.json](./dashboard.json))
- CLI deployment output
- Screenshots ([outputs pics/Project 21](../outputs%20pics/Project%2021/))

## Result
Created the `Project21-EC2-Monitoring` CloudWatch dashboard with the AWS CLI.
It monitors CPU, network traffic, and status checks for EC2 instance `i-06ad9757a3d3f9f67`.
The status check stayed at 0 for the whole window, so the instance was healthy.

