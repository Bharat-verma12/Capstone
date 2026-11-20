# Project 3: EC2 Monitoring with a CloudWatch CPU Alarm (Terraform)

## Goal
Launch an EC2 instance and monitor its CPU usage with an Amazon CloudWatch alarm, all built with Terraform.

## Tasks
- Create a security group for the instance
- Launch an EC2 instance (`Monitoring-Server`)
- Create a CloudWatch alarm that triggers when average CPU usage goes above 70%

## Architecture

```
┌─────────────────── Default VPC (us-east-1) ───────────────────┐
│                                                               │
│   ┌───────────────────────────────┐                           │
│   │ EC2: Monitoring-Server        │                           │
│   │ Amazon Linux 2 · t2.micro     │                           │
│   │ SG: ec2-monitoring-sg (SSH 22)│                           │
│   └──────────────┬────────────────┘                           │
└──────────────────┼────────────────────────────────────────────┘
                   │ CPUUtilization metric (AWS/EC2)
                   ▼
        ┌──────────────────────────────┐
        │ CloudWatch Alarm             │
        │ HighCPUAlarm                 │
        │ Avg CPU > 70% for 2 × 120 s  │
        └──────────────────────────────┘
```

## Resources Created

| Resource | Name | Details |
|----------|------|---------|
| `aws_security_group` | `ec2-monitoring-sg` | Inbound SSH (22) from `0.0.0.0/0`; all outbound traffic allowed. Created in the default VPC |
| `aws_instance` | `Monitoring-Server` | AMI `ami-0c02fb55956c7d316` (Amazon Linux 2, us-east-1), `t2.micro` |
| `aws_cloudwatch_metric_alarm` | `HighCPUAlarm` | Watches `CPUUtilization` for the instance |

## CloudWatch Alarm Configuration

| Setting | Value |
|---------|-------|
| Namespace | `AWS/EC2` |
| Metric | `CPUUtilization` |
| Statistic | `Average` |
| Period | `120` seconds |
| Evaluation periods | `2` |
| Comparison | `GreaterThanThreshold` |
| Threshold | `70` % |
| Dimension | `InstanceId` = the Monitoring-Server instance |

The alarm goes into the **ALARM** state when average CPU stays above 70% for **2 periods in a row of 2 minutes each (4 minutes in total)**.

## Provider

- AWS provider `~> 5.0`
- Region: `us-east-1`, hardcoded in `provider.tf`

## Outputs

| Name | Description |
|------|-------------|
| `instance_id` | ID of the EC2 instance |
| `public_ip` | Public IP of the EC2 instance |

## Prerequisites
- Terraform
- AWS CLI set up with credentials that can manage EC2 and CloudWatch
- A default VPC in `us-east-1`

## Deploy

```powershell
cd "Project 3"
terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## Verify

```powershell
terraform output

aws cloudwatch describe-alarms --alarm-names HighCPUAlarm --region us-east-1 --query "MetricAlarms[].[AlarmName,StateValue]" --output table
```

You can also check in the AWS Console under **CloudWatch → Alarms → HighCPUAlarm**.

> A new alarm may show **INSUFFICIENT_DATA** for a few minutes until CloudWatch has enough metric data points. It then changes to **OK**.

### Optional: Test the alarm

To push CPU above 70%, connect to the instance and run a stress test. The instance has no key pair, so connecting needs EC2 Instance Connect or a key pair you add yourself.

```bash
sudo amazon-linux-extras install epel -y
sudo yum install stress -y
stress --cpu 2 --timeout 600
```

After about 4–6 minutes, the alarm should change to **ALARM**.

## Screenshots

![Project 3 - 1](../outputs%20pics/Project%203/Screenshot%202026-11-19%20222241.png)
![Project 3 - 2](../outputs%20pics/Project%203/Screenshot%202026-11-19%20223626.png)
![Project 3 - 3](../outputs%20pics/Project%203/Screenshot%202026-11-19%20230047.png)

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `terraform output` says "No outputs found" | Run the command from inside the `Project 3` folder, or use `terraform -chdir="Project 3" output` |
| `InvalidAMIID.NotFound` | The AMI ID only exists in `us-east-1`. Keep that region or change the AMI |
| `VPCIdNotSpecified` / no default VPC | Create a default VPC with `aws ec2 create-default-vpc`, or add `vpc_id` and `subnet_id` |
| Alarm stays in `INSUFFICIENT_DATA` | Wait several minutes. EC2 basic monitoring sends metrics every 5 minutes |

## Clean Up

```powershell
terraform destroy
```

## Security & Limitations
- SSH (port 22) is open to `0.0.0.0/0`. Limit it to your own IP for anything other than a demo.
- The alarm has **no `alarm_actions`**, so it only changes state and sends no notification. To get emails, add an SNS topic and subscription and set `alarm_actions = [aws_sns_topic.alerts.arn]`.
- The AMI ID is hardcoded. A `data "aws_ami"` lookup would keep it current and work in any region.

## Possible Enhancements
- SNS email notifications for the alarm
- Turn on detailed monitoring (`monitoring = true`) to get 1-minute metrics
- More alarms, for example on `StatusCheckFailed` or network usage
- A CloudWatch dashboard
- Move the region, instance type and threshold into `variables.tf`

## File Structure

```
Project 3/
├── provider.tf     # Terraform & AWS provider configuration
├── main.tf         # Security group, EC2 instance, CloudWatch alarm
├── outputs.tf      # instance_id, public_ip
├── variables.tf    # Currently empty
└── readme.md
```