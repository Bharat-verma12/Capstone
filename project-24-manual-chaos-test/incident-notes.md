
# Project 24: Manual Chaos Test

## Objective
Test service recovery after a manually simulated failure.

## Environment
- Platform: Linux VM
- Service: Nginx
- Testing method: Manual Chaos Testing

## Incident Summary
A controlled service outage was simulated by stopping Nginx.

## Test Procedure
1. Started the Nginx service.
2. Verified that the service was running.
3. Confirmed HTTP 200 response.
4. Stopped Nginx manually.
5. Verified that the service became inactive.
6. Confirmed HTTP connection failure.
7. Restarted Nginx.
8. Verified the service and HTTP response.

## Incident Timeline
- Failure start: [Enter time]
- Service restarted: [Enter time]
- Recovery verified: [Enter time]
- Total downtime: [Enter duration]

## Results
- Service stopped successfully: [Yes/No]
- Failure detected: [Yes/No]
- Service restarted successfully: [Yes/No]
- HTTP response restored: [Yes/No]

## Conclusion
The manual chaos test demonstrated service recovery after an intentional outage. Recovery was performed manually and verified using systemctl and curl.
