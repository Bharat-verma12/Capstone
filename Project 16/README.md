# Project 16: Enable HTTPS using ACM

## Goal
Secure web access by serving the application over HTTPS using an AWS Certificate Manager (ACM) certificate.

## Architecture
Client → Application Load Balancer (HTTPS :443, ACM certificate) → Target Group → EC2 instances  
HTTP (:80) is blocked / not served directly; it is redirected to HTTPS or denied.

## Tasks
1. **Request a certificate in ACM**
   - Request a public certificate for your domain and validate it (DNS or email).
2. **Set up the ALB + HTTPS listener**
   - Create an internet-facing Application Load Balancer with a target group pointing to the web servers.
   - Add an HTTPS listener on port 443 and attach the ACM certificate.
   - Forward traffic to the target group.
3. **Block HTTP**
   - Remove the port 80 listener, or replace it with a 301 redirect to HTTPS.
   - In the ALB security group, allow inbound 443 only (remove the port 80 rule).
   - Restrict instance security groups to accept traffic only from the ALB security group.
4. **Verify**
   - Browse to `https://<your-domain>` and confirm the padlock and valid certificate.
   - Confirm `http://<your-domain>` does not serve content.

## Deliverables
- HTTPS screenshot

## Tools / Services
AWS ACM, Elastic Load Balancing (ALB), EC2, Security Groups, Route 53 (optional)
