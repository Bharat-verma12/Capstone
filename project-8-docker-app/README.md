# Project 8 - Build and Run Docker App Locally

## Objective
Build a Docker image for a simple static web app and run it as a container on a Linux VM.

## Tech Stack
- Docker
- Nginx (`nginx:alpine` base image)
- Linux VM (Ubuntu)

## Project Structure
```
project-8-docker-app/
├── Dockerfile
├── index.html
└── README.md
```

## Dockerfile
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

![Dockerfile and project files](../outputs%20pics/Project%208/Screenshot%202026-11-24%20095458.png)

## Steps

### 1. Build the image
```bash
docker build -t project8-app:v1 .
docker images project8-app
```

![Docker image built](../outputs%20pics/Project%208/Screenshot%202026-11-24%20095554.png)

### 2. Run the container
```bash
docker run -d --name project8-container -p 8080:80 project8-app:v1
```

### 3. Verify the container is running
```bash
docker ps
```

![Container running](../outputs%20pics/Project%208/Screenshot%202026-11-24%20095718.png)

### 4. Access the application
```bash
curl http://localhost:8080
```
Or open `http://localhost:8080` in a browser.

![App in browser](../outputs%20pics/Project%208/Screenshot%202026-11-24%20095823.png)

## Result
- Built the `project8-app:v1` image (about 28.8 MB) from `nginx:alpine`.
- `project8-container` is running, with host port **8080** mapped to container port **80**.
- The web page loads at `http://localhost:8080`.

## Cleanup
```bash
docker stop project8-container
docker rm project8-container
docker rmi project8-app:v1
```
