# Project 24: Manual Chaos Test

## Goal
Check that a service can be recovered after a deliberate failure, using manual chaos testing.

## Environment
- Platform: Linux VM (Ubuntu)
- Host: AZLTT0222435e27
- Service: Nginx 1.24.0 (Ubuntu)
- Tools: systemctl, curl
- Testing method: Manual Chaos Testing

## Implementation
1. Checked that Nginx was running.
2. Confirmed an HTTP 200 response.
3. Stopped Nginx manually to simulate a failure.
4. Checked that the service became inactive.
5. Confirmed that HTTP connections failed.
6. Restarted Nginx.
7. Checked the service status and HTTP response again.

## Verification Commands
```bash
# Baseline
sudo systemctl status nginx --no-pager
curl -I http://localhost

# Simulate failure
sudo systemctl stop nginx
sudo systemctl status nginx --no-pager
curl -I --max-time 5 http://localhost

# Recovery
sudo systemctl start nginx
sudo systemctl status nginx --no-pager
curl -I http://localhost
```

## Test Evidence

### 1. Baseline: Nginx running
Nginx was `active (running)` from 18:49:43 UTC, with one master process and 4 worker processes.

![Nginx active](../outputs%20pics/Project%2024/Screenshot%202026-11-22%20010817.png)

### 2. Baseline: HTTP 200 OK
`curl -I http://localhost` returned `HTTP/1.1 200 OK` from `nginx/1.24.0 (Ubuntu)`.

![HTTP 200 OK](../outputs%20pics/Project%2024/Screenshot%202026-11-22%20010840.png)

### 3. Failure: Nginx stopped
Nginx was stopped at 19:38:47 UTC. The status shows `inactive (dead)` and `Deactivated successfully`.

![Nginx inactive](../outputs%20pics/Project%2024/Screenshot%202026-11-22%20010906.png)

### 4. Failure: HTTP connection refused
`curl: (7) Failed to connect to localhost port 80 after 0 ms: Couldn't connect to server`

![Connection failed](../outputs%20pics/Project%2024/Screenshot%202026-11-22%20010924.png)

## Incident Timeline (UTC, 21 Nov 2026)
| Event               | Time         |
|---------------------|--------------|
| Nginx started       | 18:49:43     |
| HTTP 200 checked    | 19:38:25     |
| Failure start       | 19:38:47     |
| Service restarted   | [Enter time] |
| Recovery verified   | [Enter time] |
| Total downtime      | [Enter duration] |

## Results
| Stage    | Service Status   | HTTP Response      | Outcome |
|----------|------------------|--------------------|---------|
| Baseline | active (running) | HTTP/1.1 200 OK    | ✅ |
| Failure  | inactive (dead)  | Connection refused | ✅ Failure detected |
| Recovery | [active]         | [HTTP/1.1 200 OK]  | [ ] |

## Deliverables
- Incident notes ([incident-notes.md](./incident-notes.md))
- systemctl and curl command output
- Incident timeline
- Screenshots ([outputs pics/Project 24](../outputs%20pics/Project%2024/))

## Result
The manual chaos test simulated an Nginx outage. The failure was confirmed with
systemctl (`inactive (dead)`) and curl (connection refused on port 80).
The service was then restarted manually and checked with systemctl and curl.