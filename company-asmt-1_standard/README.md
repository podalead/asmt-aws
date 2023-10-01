# Headway test task

### Requirements

 - terraform > v0.14
 - terragrunt


### Initial conditions

 - IAM role for provisioning (all required policies in automation_policy.json)
 - State bucket
 - AMI created with default config in Image builder (docker mandatory, ssm desired)

### How to run locally
- Export aws keys or another way to access your account
```
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=
```
- Change dir to `cd terragrunt/non-prod`
- Execute `terragrunt run-all apply`

### How to run autonomously
<i>If you have specific permission to this repo 
or you can reach out to repo owner to run automatic provision</i>