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

## Implementation

1. Created two Ubuntu EC2 instances.
2. Configured Nginx using EC2 User Data.
3. Registered both instances in an HTTP target group on port 80.
4. Configured security group rules for ALB-to-EC2 communication.
5. Verified an existing Application Load Balancer in the assigned VPC.
6. Inspected the ALB listeners and target group configuration.

## Existing Load Balancer Configuration

- ALB Name: project20-alb
- Region: us-east-1
- Scheme: Internet-facing
- HTTPS Listener: Port 443
- HTTP Listener: Port 80, returns HTTP 403
- HTTPS Target Group: project20-tg

## Security

- No inbound SSH port 22.
- No inbound RDP port 3389.
- HTTP access through the load balancer is restricted.
- HTTPS is configured on the existing ALB.

## Verification

The two EC2 instances were confirmed registered in project20-target-group. Both initially showed `unused` before attachment to an ALB listener.

Final target health and application load-distribution testing remain to be verified.

## Screenshots

Deployment evidence can be stored in the `screenshots/` directory.
