# Project 17: Log Forwarding to CloudWatch

## Goal
Central log management by forwarding server logs to Amazon CloudWatch Logs.

## Architecture
EC2 instance (CloudWatch agent) → CloudWatch Logs (log groups / streams) → CloudWatch Console dashboard

## Tasks
1. **Grant permissions**
   - Attach an IAM role with the `CloudWatchAgentServerPolicy` managed policy to the EC2 instance.
2. **Install the log agent**
   - Run `setup_cloudwatch_agent.sh` on the instance (installs `amazon-cloudwatch-agent`).
3. **Send logs to CloudWatch**
   - `amazon-cloudwatch-agent.json` ships `/var/log/messages`, `/var/log/secure` and the Nginx access/error logs
     to the log groups `project17-system-logs` and `project17-nginx-logs`.
   - Adjust `file_path` entries to match your server.
4. **Verify**
   - CloudWatch → Logs → Log groups → open the groups and confirm streams per instance ID with live events.
   - Optionally create a dashboard with a Logs Insights widget.

## Files
| File | Purpose |
|------|---------|
| `amazon-cloudwatch-agent.json` | Agent configuration (log files → log groups) |
| `setup_cloudwatch_agent.sh` | Installs, configures and starts the agent |

## Usage
```bash
chmod +x setup_cloudwatch_agent.sh
./setup_cloudwatch_agent.sh
```

## Deliverables
- Log dashboard screenshot (save in `outputs pics`)

## Tools / Services
AWS CloudWatch Logs, CloudWatch Agent, EC2, IAM
