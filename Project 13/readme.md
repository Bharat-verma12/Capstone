# Project 13: Build Docker Image and Push to AWS ECR

## 📌 Project Overview

This project demonstrates how to build a Docker image for a web application, run it inside a Docker container, and push the image to **Amazon Elastic Container Registry (ECR)**.

The project uses a Linux Virtual Machine (VM) to perform Docker operations and AWS CLI commands to interact with Amazon ECR.

The main objective is to understand containerization and cloud-based Docker image management using AWS.

## 🎯 Objectives

- Install and configure Docker on a Linux VM.
- Create a simple web application.
- Write a Dockerfile to containerize the application.
- Build a Docker image.
- Run and test the Docker container locally.
- Create a private repository in Amazon ECR.
- Authenticate Docker with AWS ECR.
- Tag and push the Docker image to ECR.
- Verify the uploaded image in AWS.

## 🏗️ Project Architecture

```text
        Linux Virtual Machine
                 |
                 v
        Create Web Application
                 |
                 v
            Dockerfile
                 |
                 v
         Build Docker Image
                 |
                 v
       Run Docker Container
                 |
                 v
          Test Application
                 |
                 v
          AWS CLI Login
                 |
                 v
        Amazon ECR Repository
                 |
                 v
          Push Docker Image
                 |
                 v
          Verify Image
```

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Linux (Ubuntu) | Virtual machine environment |
| Docker | Containerization |
| Dockerfile | Image creation instructions |
| AWS CLI | AWS resource management |
| Amazon ECR | Docker image storage |
| Nginx | Web server |
| HTML | Sample web application |

## 📁 Project Structure

```text
ecr-project/
│
├── Dockerfile
│
└── index.html
```

## ⚙️ Step 1: Install Docker

Update the Linux packages:

```bash
sudo apt update
sudo apt upgrade -y
```

Install Docker and its components:

```bash
sudo apt install -y docker.io
```

Verify Docker installation:

```bash
sudo docker --version
```

Test Docker:

```bash
sudo docker run hello-world
```

## 🌐 Step 2: Create a Web Application

Create the project directory:

```bash
mkdir ecr-project
cd ecr-project
```

Create an HTML file:

```bash
nano index.html
```

Add the following content:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Project 13</title>
</head>
<body>
    <h1>My Docker App</h1>
    <p>Successfully built and pushed to Amazon ECR!</p>
</body>
</html>
```

## 🐳 Step 3: Create a Dockerfile

Create a file named `Dockerfile`:

```dockerfile
FROM nginx:latest

COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
```

## 🔨 Step 4: Build the Docker Image

Build the Docker image:

```bash
sudo docker build -t myapp:latest .
```

Verify the image:

```bash
sudo docker images
```

## 🚀 Step 5: Run the Docker Container

Start the container:

```bash
sudo docker run -d -p 8080:80 --name myapp-container myapp:latest
```

Check running containers:

```bash
sudo docker ps
```

Test the application:

```bash
curl http://localhost:8080
```

The application should return the HTML content.

## ☁️ Step 6: Configure AWS CLI

Verify AWS CLI:

```bash
aws --version
```

Configure AWS credentials if required:

```bash
aws configure
```

Verify AWS identity:

```bash
aws sts get-caller-identity
```

## 📦 Step 7: Create an Amazon ECR Repository

Create a private ECR repository:

```bash
aws ecr create-repository \
  --repository-name myapp \
  --region us-east-1
```

Repository details:

| Configuration | Value |
|---|---|
| Repository Name | myapp |
| AWS Region | us-east-1 |
| Registry ID | 590507089733 |
| Repository Type | Private |
| Encryption | AES256 |

## 🔐 Step 8: Authenticate Docker with Amazon ECR

Run the following command:

```bash
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin 590507089733.dkr.ecr.us-east-1.amazonaws.com
```

Expected output:

```text
Login Succeeded
```

## 🏷️ Step 9: Tag the Docker Image

Tag the local Docker image with the ECR repository URI:

```bash
sudo docker tag myapp:latest 590507089733.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
```

## 📤 Step 10: Push the Docker Image to ECR

Push the image:

```bash
sudo docker push 590507089733.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
```

After successful execution, AWS ECR stores the Docker image in the private repository.

## ✅ Step 11: Verify the Uploaded Image

Execute:

```bash
aws ecr describe-images \
  --repository-name myapp \
  --region us-east-1
```

The image was successfully uploaded and verified.

### Upload Verification Details

| Parameter | Value |
|---|---|
| Repository | myapp |
| Image Tag | latest |
| Image Status | ACTIVE |
| Image Size | Approximately 63.9 MB |
| AWS Region | us-east-1 |
| Push Status | Successful |

**Image Digest:**

```text
sha256:3f9816c8e97cfe1f0fbfeff1d5405dec49cee9824f084a94dbde5d7b764d3f1b
```

## 🎉 Project Outcome

Successfully completed the Docker image creation and deployment-to-registry workflow.

- Docker successfully installed on the Linux VM.
- Sample web application containerized using Docker.
- Docker image built and tested locally.
- Private AWS ECR repository created.
- Docker authenticated with AWS ECR.
- Image successfully tagged and pushed.
- Uploaded image verified through AWS CLI.

## 🔗 AWS Resources

- [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/)
- [Docker Documentation](https://docs.docker.com/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)

## 👨‍💻 Author

**Bharat Verma**

Project: Build Docker Image and Push to AWS ECR

## 📄 License

This project is created for educational and learning purposes.