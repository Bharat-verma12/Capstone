# Project 17: Log Forwarding to CloudWatch

## Goal
Manage server logs in one place by forwarding them to Amazon CloudWatch Logs.

## Architecture
EC2 instance (CloudWatch agent) → CloudWatch Logs (log groups and streams) → CloudWatch Console / Logs Insights

## Tools / Services
- Amazon EC2 (Amazon Linux)
- Amazon CloudWatch Agent
- Amazon CloudWatch Logs
- AWS IAM
- Nginx
- GitHub Actions

## Log Mapping
| Source File                 | Log Group              | Log Stream               | Retention |
|-----------------------------|------------------------|--------------------------|-----------|
| `/var/log/messages`         | project17-system-logs  | `{instance_id}/messages` | 7 days |
| `/var/log/secure`           | project17-system-logs  | `{instance_id}/secure`   | 7 days |
| `/var/log/nginx/access.log` | project17-nginx-logs   | `{instance_id}/access`   | 7 days |
| `/var/log/nginx/error.log`  | project17-nginx-logs   | `{instance_id}/error`    | 7 days |

The agent runs as `root` and collects metrics every 60 seconds.

## Files
| File | Purpose |
|------|---------|
| [amazon-cloudwatch-agent.json](./amazon-cloudwatch-agent.json) | Agent configuration (which log files go to which log groups) |
| [setup_cloudwatch_agent.sh](./setup_cloudwatch_agent.sh) | Installs, configures, and starts the agent |

## Tasks
1. **Grant permissions**
   - Attach an IAM role with the `CloudWatchAgentServerPolicy` managed policy to the EC2 instance.
2. **Install the log agent**
   - Run `setup_cloudwatch_agent.sh` on the instance. It installs `amazon-cloudwatch-agent` with `yum`.
3. **Send logs to CloudWatch**
   - The script copies the config to `/opt/aws/amazon-cloudwatch-agent/etc/`, loads it with
     `fetch-config -m ec2 -s`, and enables the agent at boot.
   - Change the `file_path` entries to match your server.
4. **Verify**
   - CloudWatch → Logs → Log groups → open `project17-system-logs` and `project17-nginx-logs`,
     and check for one stream per instance ID with new events.
   - Optionally create a dashboard with a Logs Insights widget.

## Usage
```bash
chmod +x setup_cloudwatch_agent.sh
./setup_cloudwatch_agent.sh
```

Setup script:
```bash
sudo yum install -y amazon-cloudwatch-agent

sudo cp amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

sudo systemctl enable amazon-cloudwatch-agent
sudo systemctl status amazon-cloudwatch-agent --no-pager
```

## Verification Commands
```bash
# Agent status on the instance
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a status

# Log groups
aws logs describe-log-groups --log-group-name-prefix project17 --region us-east-1

# Log streams
aws logs describe-log-streams --log-group-name project17-nginx-logs --region us-east-1

# Generate Nginx traffic and follow the logs
curl -s http://localhost > /dev/null
aws logs tail project17-nginx-logs --follow --region us-east-1
```

## Test Evidence

### 1. Commit pushed to `main`
Commit `85014aa` ("Add CloudWatch log forwarding setup for Project 17") was pushed to `main`.
The repo's **Terraform Validation #18** (17s) and **Terraform Plan #10** (19s) workflows passed on it.

![GitHub Actions](../outputs%20pics/Project%2017/Screenshot%202026-11-21%20123712.png)

### 2. CloudWatch agent running
[Add a screenshot of `amazon-cloudwatch-agent-ctl -a status` showing `"status": "running"`.]

### 3. Log groups and streams
[Add a screenshot of CloudWatch → Log groups showing `project17-system-logs` and `project17-nginx-logs`
with streams per instance ID.]

### 4. Log events
[Add a screenshot of Nginx access log events in CloudWatch (or a Logs Insights query).]

## Notes
- On **Amazon Linux 2023**, `/var/log/messages` and `/var/log/secure` don't exist by default
  (system logs go to journald). Install `rsyslog`, or remove those entries, to avoid empty streams.
- Log groups keep logs for **7 days** to keep costs low.

## Deliverables
- Agent configuration ([amazon-cloudwatch-agent.json](./amazon-cloudwatch-agent.json))
- Setup script ([setup_cloudwatch_agent.sh](./setup_cloudwatch_agent.sh))
- Log dashboard screenshots ([outputs pics/Project 17](../outputs%20pics/Project%2017/))

## Result
Set up the CloudWatch agent to forward system and Nginx logs from EC2 to CloudWatch Logs,
grouped by log type and instance ID, with 7-day retention. The setup was committed to `main`.
