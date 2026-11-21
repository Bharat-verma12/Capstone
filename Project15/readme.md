# Project 15: Automating Nginx Web Server Setup with Ansible

## Objective
Use an Ansible playbook to install, configure, and start an **Nginx** web server automatically, then deploy a custom homepage.

## Tools Used
| Tool | Purpose |
| --- | --- |
| Ansible (core 2.16.3) | Configuration management / automation |
| Nginx | Web server |
| Ubuntu (Python 3.12.3) | Target host |

## Project Structure
```
Project15/
├── inventory.ini       # Target hosts
├── install_nginx.yml   # Playbook that installs and configures Nginx
└── readme.md
```

## Files

### inventory.ini
Defines a `webservers` group that targets the local machine:
```ini
[webservers]
localhost ansible_connection=local
```

### install_nginx.yml
The playbook runs these tasks with `become: yes` (sudo):
1. **Update apt cache**: refreshes the package index.
2. **Install Nginx**: installs the `nginx` package.
3. **Start and enable Nginx**: starts the service and enables it to start at boot.
4. **Deploy custom homepage**: writes a custom `index.html` to `/var/www/html/`.

## Steps to Run

### 1. Verify the Ansible installation
```bash
ansible --version
```
![Ansible version](../outputs%20pics/Project%2015/Screenshot%202026-11-21%20091707.png)

### 2. Test connectivity to the inventory
```bash
ansible -i inventory.ini webservers -m ping
```
The host responds with `"ping": "pong"`, so Ansible can reach the target.

![Ansible ping](../outputs%20pics/Project%2015/Screenshot%202026-11-21%20091918.png)

### 3. Run the playbook
```bash
ansible-playbook -i inventory.ini install_nginx.yml --ask-become-pass
```
All tasks complete successfully. Play recap: `ok=5 changed=3 unreachable=0 failed=0`.

![Playbook execution](../outputs%20pics/Project%2015/Screenshot%202026-11-21%20092117.png)

### 4. Verify in the browser
Open `http://<server-ip>` (here `http://10.5.2.112`). The custom homepage served by Nginx appears:

![Nginx homepage](../outputs%20pics/Project%2015/Screenshot%202026-11-21%20092231.png)

## Result
- Ansible is installed and can reach the target host.
- Nginx was installed, started, and enabled automatically.
- The custom homepage, **"Welcome to Ansible Automation!"**, is served by Nginx.
- Running the playbook again gives the same result (it is **idempotent**): tasks report `ok` instead of `changed`.

## Cleanup (optional)
```bash
sudo systemctl stop nginx
sudo apt remove -y nginx
```