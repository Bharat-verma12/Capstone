# Project 14: App Deployment using EKS

Goal: deploy an app on Kubernetes (EKS) and expose it publicly.

## Steps
1. Provision EKS:
   ```
   cd terraform
   terraform init
   terraform apply
   aws eks update-kubeconfig --region ap-south-1 --name project14-eks
   ```
2. Deploy and expose the app (LoadBalancer service):
   ```
   kubectl apply -f k8s/app.yaml
   kubectl get svc demo-app -w
   ```
3. Open the `EXTERNAL-IP` in a browser and save a screenshot as `screenshots/public-access.png`.

## Cleanup
```
kubectl delete -f k8s/app.yaml
cd terraform; terraform destroy
```
