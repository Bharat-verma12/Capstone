# Project 14: App Deployment using EKS

## Goal
Deploy an app on Kubernetes (Amazon EKS) and make it publicly accessible.

## Technologies
- Amazon EKS
- Terraform (`terraform-aws-modules/eks/aws` ~> 20.0)
- Kubernetes (kubectl)
- AWS Elastic Load Balancer
- Nginx

## Resources
| Resource          | Value |
|-------------------|-------|
| Region            | ap-south-1 (Mumbai) |
| Cluster Name      | project14-eks |
| Kubernetes        | 1.35 |
| Node Group        | default (AL2023, t3.medium, 2 nodes, min 1 / max 3) |
| Network           | Default VPC and its default subnets |
| Deployment        | demo-app (2 replicas, `nginx:stable`) |
| Service           | demo-app (LoadBalancer, port 80) |
| Public URL        | http://afc11089c3c0945eca49904ab0fe8920-1939322224.ap-south-1.elb.amazonaws.com |

## Project Structure
```
project14/
├── terraform/
│   └── main.tf      # EKS cluster, node group, ELB subnet tags
└── k8s/
    └── app.yaml     # demo-app Deployment and LoadBalancer Service
```

## Steps

### 1. Create the EKS cluster
```bash
cd terraform
terraform init
terraform apply
aws eks update-kubeconfig --region ap-south-1 --name project14-eks
```

### 2. Check the worker nodes
```bash
kubectl get nodes
```

### 3. Deploy and expose the app
```bash
cd ..
kubectl apply -f k8s/app.yaml
kubectl get svc demo-app -w
kubectl get pods
```

### 4. Open the app
Open the `EXTERNAL-IP` (ELB DNS name) in a browser.

## Test Evidence

### 1. EKS cluster created
`terraform apply` finished with **8 added, 0 changed, 0 destroyed**. The managed node group
`project14-eks:default` was created in 1m48s.

![Terraform apply](../outputs%20pics/Project%2014/Screenshot%202026-11-21%20010023.png)

### 2. Nodes ready, app deployed
- 2 worker nodes are `Ready` on `v1.35.9-eks`.
- `kubectl apply` created the `demo-app` deployment and service.
- The service went from `<pending>` to an ELB hostname in a few seconds.

![Nodes and service](../outputs%20pics/Project%2014/Screenshot%202026-11-21%20010234.png)

### 3. Pods running
Both `demo-app` pods are `1/1 Running` with 0 restarts.

![Pods](../outputs%20pics/Project%2014/Screenshot%202026-11-21%20010325.png)

### 4. Public LoadBalancer
The `demo-app` service is exposed at
`afc11089c3c0945eca49904ab0fe8920-1939322224.ap-south-1.elb.amazonaws.com` on port 80.

![Service external IP](../outputs%20pics/Project%2014/Screenshot%202026-11-21%20010412.png)

### 5. Public access in a browser
[Add a screenshot of the Nginx welcome page opened at the ELB URL.]

## Challenges
- **Wrong Terraform config applied:** before the final deployment, a Terraform run in `project14/terraform`
  used config from another project. That run created the IAM user `bharat-s3-read-user`
  (`AmazonS3ReadOnlyAccess`) and **destroyed 11 EKS resources** (cluster and node IAM roles and policies).
  The EKS config was restored and applied again, which produced the successful deployment above.
  Each Terraform project should have its own folder and state file.

  ![Wrong config applied](../outputs%20pics/Project%2014/Screenshot%202026-11-21%20001953.png)

- **Existing resources:** `import` blocks in `main.tf` bring the existing KMS alias and CloudWatch log group
  into Terraform state, so a fresh `apply` doesn't fail because they already exist.

## Cleanup
```bash
kubectl delete -f k8s/app.yaml
cd terraform
terraform destroy
```

## Result
Created an EKS cluster (`project14-eks`) with Terraform and deployed a 2-replica Nginx app.
The app is exposed to the internet through a Kubernetes `LoadBalancer` service backed by an AWS ELB.
