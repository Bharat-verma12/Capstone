# Project 16: Enable HTTPS using ACM

## Goal
Secure web access by serving the application over HTTPS using an AWS Certificate Manager (ACM) certificate.

## Architecture
```
Client ──HTTPS :443──► Application Load Balancer (ACM certificate) ──HTTP :80──► Target Group ──► EC2 instances
Client ──HTTP  :80───► ALB → 301 redirect to HTTPS (or blocked)
```

## Tools / Services
- AWS Certificate Manager (ACM)
- Elastic Load Balancing (Application Load Balancer)
- Amazon EC2
- Security Groups
- Route 53 (optional, for DNS validation and the domain record)
- AWS CLI

## Resources
| Resource            | Value |
|---------------------|-------|
| Region              | us-east-1 |
| Domain              | [your-domain] |
| ACM Certificate ARN | [certificate-arn] |
| Load Balancer       | [alb-name] |
| Target Group        | [target-group-name] |
| ALB Security Group  | [alb-sg-id] |
| EC2 Security Group  | [ec2-sg-id] |

## Tasks

### 1. Request a certificate in ACM
Request a public certificate for your domain and validate it (DNS validation is recommended).

```bash
aws acm request-certificate \
  --domain-name <your-domain> \
  --validation-method DNS \
  --region us-east-1

# Get the CNAME record needed for DNS validation
aws acm describe-certificate --certificate-arn <certificate-arn> \
  --query "Certificate.DomainValidationOptions[].ResourceRecord"

# Check the certificate was issued
aws acm describe-certificate --certificate-arn <certificate-arn> \
  --query "Certificate.Status"
```

### 2. Set up the ALB and HTTPS listener
- Create an internet-facing Application Load Balancer with a target group for the web servers.
- Add an HTTPS listener on port 443 and attach the ACM certificate.
- Forward traffic to the target group.

```bash
aws elbv2 create-listener \
  --load-balancer-arn <alb-arn> \
  --protocol HTTPS --port 443 \
  --certificates CertificateArn=<certificate-arn> \
  --ssl-policy ELBSecurityPolicy-TLS13-1-2-2021-06 \
  --default-actions Type=forward,TargetGroupArn=<target-group-arn>
```

### 3. Block or redirect HTTP
- Remove the port 80 listener, or replace it with a 301 redirect to HTTPS.
- In the ALB security group, allow inbound traffic on port 443 only (plus port 80 if you use the redirect).
- Set the instance security groups to accept traffic only from the ALB security group.

```bash
# Redirect HTTP to HTTPS
aws elbv2 create-listener \
  --load-balancer-arn <alb-arn> \
  --protocol HTTP --port 80 \
  --default-actions 'Type=redirect,RedirectConfig={Protocol=HTTPS,Port=443,StatusCode=HTTP_301}'

# Allow traffic to the instances only from the ALB
aws ec2 authorize-security-group-ingress \
  --group-id <ec2-sg-id> \
  --protocol tcp --port 80 \
  --source-group <alb-sg-id>
```

### 4. Verify
```bash
# HTTPS works with a valid certificate
curl -I https://<your-domain>

# HTTP redirects to HTTPS (301) or does not serve content
curl -I http://<your-domain>

# Listener configuration
aws elbv2 describe-listeners --load-balancer-arn <alb-arn> \
  --query "Listeners[].[Port,Protocol,DefaultActions[0].Type]" --output table
```

## Expected Results
| Check | Expected |
|-------|----------|
| ACM certificate status | `ISSUED` |
| `https://<your-domain>` | `HTTP/1.1 200 OK`, browser shows padlock |
| `http://<your-domain>` | `301` redirect to HTTPS, or blocked |
| ALB listeners | `443 HTTPS forward`, `80 HTTP redirect` (or none) |
| Direct access to EC2 | Blocked (only the ALB security group is allowed) |

## Test Evidence
Screenshots go in `outputs pics/Project 16/`.

### 1. ACM certificate issued
[Add a screenshot of the ACM console showing the certificate status as **Issued**.]

### 2. ALB listeners
[Add a screenshot of the ALB **Listeners and rules** tab showing HTTPS :443 with the ACM certificate.]

### 3. HTTPS in the browser
[Add a screenshot of `https://<your-domain>` with the padlock and certificate details.]

### 4. HTTP blocked or redirected
[Add a screenshot of `curl -I http://<your-domain>` showing the `301` redirect, or the blocked request.]

## Deliverables
- HTTPS screenshot
- ACM certificate and ALB listener configuration
- Security group rules

## Result
[Summarize what you saw, for example: the application is served over HTTPS at `https://<your-domain>`
with an ACM certificate on the ALB. HTTP requests are redirected to HTTPS, and the EC2 instances
accept traffic only from the ALB.]
