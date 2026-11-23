# Project 15: Automating Nginx Web Server Setup with Ansible

## Objective
Use an Ansible playbook to install, configure, and start an **Nginx** web server automatically, then deploy a custom homepage.

## Tools Used
| Tool | Purpose |
| --- | --- |
| Ansible (core 2.16.3) | Configuration management / automation |
| Nginx | Web server |
| Ubuntu (Python 3.12.3) | Target host |

## Environment
| Item | Value |
| --- | --- |
| Host | AZLTT0222435e27 (Ubuntu Linux VM) |
| User | clouduser |
| Server IP | 10.5.2.112 |
| Ansible | core 2.16.3, Jinja 3.1.2 |
| Python | 3.12.3 (`/usr/bin/python3`) |
| Connection | Local (`ansible_connection=local`) |

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

```yaml
---
- name: Automate Nginx Web Server Installation
  hosts: webservers
  become: yes

  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes

    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Start and enable Nginx
      service:
        name: nginx
        state: started
        enabled: yes

    - name: Deploy custom homepage
      copy:
        dest: /var/www/html/index.html
        content: |
          <!DOCTYPE html>
          <html>
          <head>
              <title>Ansible Project</title>
          </head>
          <body>
              <h1>Welcome to Ansible Automation!</h1>
              <p>Nginx deployed using Ansible Playbook.</p>
          </body>
          </html>
```

## Steps to Run

### 1. Check the Ansible installation
```bash
ansible --version
```
Ansible core 2.16.3 is installed and uses Python 3.12.3.

![Ansible version](../outputs%20pics/Project%2015/Screenshot%202026-11-21%20091707.png)

### 2. Test connectivity to the inventory
```bash
ansible -i inventory.ini webservers -m ping
```
`localhost` returns `SUCCESS` with `"ping": "pong"`, so Ansible can reach the target.

![Ansible ping](../outputs%20pics/Project%2015/Screenshot%202026-11-21%20091918.png)

### 3. Run the playbook
```bash
ansible-playbook -i inventory.ini install_nginx.yml --ask-become-pass
```

| Task | Result |
| --- | --- |
| Gathering Facts | ok |
| Update apt cache | changed |
| Install Nginx | changed |
| Start and enable Nginx | ok (the service was already started when the package was installed) |
| Deploy custom homepage | changed |

Play recap: `ok=5 changed=3 unreachable=0 failed=0 skipped=0 rescued=0 ignored=0`.

![Playbook execution](../outputs%20pics/Project%2015/Screenshot%202026-11-21%20092117.png)

### 4. Check in the browser
Open `http://<server-ip>` (here `http://10.5.2.112`). Nginx serves the custom homepage,
**"Welcome to Ansible Automation!"**.

![Nginx homepage](../outputs%20pics/Project%2015/Screenshot%202026-11-21%20092231.png)

## Result
- Ansible is installed and can reach the target host.
- Nginx was installed, started, and enabled at boot automatically.
- Nginx serves the custom homepage, **"Welcome to Ansible Automation!"**, at `http://10.5.2.112`.
- The playbook is safe to run again. On a second run, `Install Nginx`, `Start and enable Nginx`,
  and `Deploy custom homepage` report `ok`. `Update apt cache` always reports `changed`,
  because it refreshes the cache every run unless `cache_valid_time` is set.

## Deliverables
- Inventory file ([inventory.ini](./inventory.ini))
- Ansible playbook ([install_nginx.yml](./install_nginx.yml))
- Playbook execution output
- Screenshots ([outputs pics/Project 15](../outputs%20pics/Project%2015/))

## Cleanup (optional)
```bash
sudo systemctl stop nginx
sudo apt remove -y nginx
```