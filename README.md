# Assessment for AWS EKS

## Infra
### Resources and EKS components
#### Resources
 - AWS VPC
 - AWS Subnets (private/public)
 - AWS Internet Gateway
 - AWS Single NAT Gateway
 - AWS Security groups
 - AWS EKS
 - AWS EKS Managed node group
 - AWS IAM OIDC (for EKS and GitHub Actions)
 - AWS IAM Roles

#### EKS Components
 - Modified EKS Auth ConfigMap
 - Installed AWS load balancer controller

### Diagram
![Infra diagram](./docs/asmt-aws-eks-infra.svg)



## Task
```
Please create Terraform automation that will deploy a VPC, an EKS cluster, and several worker nodes.
You should be able to connect to it using kubectl and run some arbitrary workload, for example a Pod or a Deployment.
```
#### Additions

*Please, don't use community modules, do all by yourself. We don't  interest in code clearance - it just need to work.*
