# Project 20: Load Balanced App Deployment on AWS

## Objective
Deploy two EC2 application servers behind an AWS Application Load Balancer to improve application availability and scalability.

## AWS Services Used
- Amazon EC2
- Application Load Balancer (ALB)
- Target Groups
- VPC and Subnets
- Security Groups
- AWS CLI
- Nginx

## Architecture

User → Application Load Balancer → Target Group → EC2 Instance 1 / EC2 Instance 2

## Resources
| Resource         | Value |
|------------------|-------|
| AWS Account      | 590507089733 |
| Region           | us-east-1 (N. Virginia) |
| VPC              | vpc-0c13a23908eefcd48 |
| EC2 Instance 1   | project20-ec2-1 — i-08cb36322deeeb1f9 (t3.micro, us-east-1c) |
| EC2 Instance 2   | project20-ec2-2 — i-0254b12fcab5fd2c3 (t3.micro, us-east-1c) |
| Instance Subnet  | subnet-0d3d4aa939b46f2b7 |
| Target Group     | project20-target-group (HTTP:80) |
| Load Balancer    | project20-alb |
| ALB DNS Name     | project20-alb-144222244.us-east-1.elb.amazonaws.com |

## Implementation

1. Created two EC2 instances (`project20-ec2-1` and `project20-ec2-2`).
2. Set up Nginx with EC2 User Data.
3. Registered both instances in an HTTP target group on port 80.
4. Set up security group rules so the ALB can reach the EC2 instances.
5. Checked the existing Application Load Balancer in the assigned VPC.
6. Inspected the ALB listeners and target group configuration.

## Commands Used
```bash
# Running project instances and their Availability Zones
aws ec2 describe-instances \
  --region us-east-1 \
  --filters "Name=tag:Name,Values=project20-ec2-*" "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].[Tags[?Key=='Name']|[0].Value,InstanceId,State.Name,Placement.AvailabilityZone]" \
  --output table

# VPC and subnet of each instance
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=project20-ec2-1,project20-ec2-2" \
  --query "Reservations[].Instances[].[InstanceId,Tags[?Key=='Name']|[0].Value,State.Name,VpcId,SubnetId]" \
  --output table

# Target group details
aws elbv2 describe-target-groups \
  --names project20-target-group \
  --query "TargetGroups[].[TargetGroupName,TargetGroupArn,VpcId]" \
  --output table

TG_ARN=$(aws elbv2 describe-target-groups \
  --names project20-target-group \
  --query "TargetGroups[0].TargetGroupArn" \
  --output text)

# Target health
aws elbv2 describe-target-health \
  --target-group-arn "$TG_ARN" \
  --query "TargetHealthDescriptions[].[Target.Id,Target.Port,TargetHealth.State,TargetHealth.Reason]" \
  --output table
```

## Load Balancer Configuration

- ALB Name: project20-alb
- Type: Application, Internet-facing, IPv4
- Status: Active
- VPC: vpc-0c13a23908eefcd48
- Availability Zones: us-east-1a (subnet-06dbf7f34d036106b), us-east-1b (subnet-0d7eb52a38aa75cfe)
- HTTPS Listener: Port 443
- HTTP Listener: Port 80, returns HTTP 403
- HTTPS Target Group: project20-tg

## Test Evidence

### 1. EC2 instances running
Both project instances are `running` in `us-east-1c`.

![Running instances (CLI)](../outputs%20pics/Project%2020/Screenshot%202026-11-21%20133635.png)

### 2. EC2 instances in the console
Both instances are t3.micro. `project20-ec2-1` passed all 3 status checks. `project20-ec2-2` was still initializing when the screenshot was taken.

![Running instances (Console)](../outputs%20pics/Project%2020/Screenshot%202026-11-21%20133728.png)

### 3. VPC and subnet
Both instances are in `vpc-0c13a23908eefcd48`, subnet `subnet-0d3d4aa939b46f2b7`.

![Instance VPC and subnet](../outputs%20pics/Project%2020/Screenshot%202026-11-21%20134215.png)

### 4. VPC and Availability Zone check
Confirmed that both instances share the same VPC and Availability Zone (`us-east-1c`).

![Instance VPC and AZ](../outputs%20pics/Project%2020/Screenshot%202026-11-21%20134332.png)

### 5. Target group ARN
`arn:aws:elasticloadbalancing:us-east-1:590507089733:targetgroup/project20-target-group/8943f51df0d37bf8`

![Target group ARN](../outputs%20pics/Project%2020/Screenshot%202026-11-21%20134406.png)

### 6. Target health
Both instances are registered on port 80 and show `unused` (`Target.NotInUse`).

![Target health](../outputs%20pics/Project%2020/Screenshot%202026-11-21%20134435.png)

### 7. Target group VPC
`project20-target-group` is in the same VPC as the instances (`vpc-0c13a23908eefcd48`).

![Target group](../outputs%20pics/Project%2020/Screenshot%202026-11-21%20134906.png)

### 8. Application Load Balancer
`project20-alb` is **Active**, internet-facing, and covers us-east-1a and us-east-1b.

![Application Load Balancer](../outputs%20pics/Project%2020/Screenshot%202026-11-21%20135837.png)

## Security

- No inbound SSH (port 22).
- No inbound RDP (port 3389).
- HTTP access through the load balancer is restricted (port 80 returns 403).
- HTTPS is configured on the existing ALB.

## Challenges
- **Targets show `unused`:** both targets report `Target.NotInUse`. There are 2 likely causes:
  1. **Availability Zone mismatch:** the instances are in `us-east-1c`, but the ALB only covers
     `us-east-1a` and `us-east-1b`. An ALB can only send traffic to targets in zones it covers.
  2. **Target group not attached to a listener:** the HTTPS listener forwards to `project20-tg`,
     not `project20-target-group`.
- **Fix:** add a `us-east-1c` subnet to the ALB (or launch the instances in 1a or 1b),
  and point a listener at `project20-target-group` (or register the instances in `project20-tg`).

## Verification

The two EC2 instances are registered in `project20-target-group` on port 80, and the ALB is active
in the same VPC. Both targets show `unused`, so they are not yet receiving traffic from the ALB.

Target health (`healthy`) and load-distribution testing through the ALB DNS name are still to be done:

```bash
curl -k https://project20-alb-144222244.us-east-1.elb.amazonaws.com
```

## Deliverables
- EC2 instance and target group CLI output
- Target health output
- ALB configuration
- Screenshots ([outputs pics/Project 20](../outputs%20pics/Project%2020/))
