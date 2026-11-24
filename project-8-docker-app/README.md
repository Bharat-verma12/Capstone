# Project 8 - Build and Run Docker App Locally

## Objective
Deploy a Docker application on a Linux VM.

## Build
docker build -t project8-app:v1 .

## Run
docker run -d --name project8-container -p 8080:80 project8-app:v1

## Verification
docker ps
curl http://localhost:8080
