# Project 10: Internal DNS Setup

## Goal

Access the app using a hostname instead of an IP address.

## Tasks

- Deploy a DNS server.
- Create an A record for the web server.

## Environment

| Item | Value |
| --- | --- |
| DNS server | `DC01` (Windows Server, AD-integrated DNS) |
| Server IP | `10.5.3.130` |
| Zone | `capstone.local` |
| A record | `webserver.capstone.local` → `10.5.3.130` |

## Steps

### 1. Deploy the DNS server

Install the DNS Server role on `DC01` and confirm the forward lookup zones are running.

![DNS Manager - forward lookup zones](../outputs%20pics/Project%2010/Screenshot%202026-11-20%20182203.png)

### 2. Check the server IP

Run `ipconfig` to get the server's IPv4 address (`10.5.3.130`).

![ipconfig output](../outputs%20pics/Project%2010/Screenshot%202026-11-20%20182333.png)

### 3. Create the A record

In DNS Manager, add a new **Host (A)** record named `webserver` that points to `10.5.3.130`.

![Host (A) record for webserver](../outputs%20pics/Project%2010/Screenshot%202026-11-20%20182524.png)

### 4. Flush the DNS cache

```powershell
ipconfig /flushdns