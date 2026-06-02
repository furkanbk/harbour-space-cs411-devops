# Terraform Infrastructure

This directory contains Terraform configuration to provision AWS infrastructure.

## Resources

- **aws_instance**: EC2 instance (t3.micro, Ubuntu)
- **aws_security_group**: Security group with SSH (22) and app port (4444) access
- **aws_key_pair**: SSH key pair for instance access

## Files

- `main.tf` - Resource definitions
- `variables.tf` - Input variables with defaults
- `outputs.tf` - Output values (instance ID, IP, DNS, etc.)
- `backend.tf` - Backend configuration (for remote state)

## Prerequisites

1. **Terraform**: v1.0 or later installed
2. **AWS CLI**: Configured with credentials
3. **AWS Credentials**: Available as environment variables or Jenkins credentials
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`

## Local Usage

```bash
cd terraform

# Initialize Terraform
terraform init

# Plan changes
terraform plan

# Apply changes
terraform apply
```

## Jenkins Integration

The pipeline automatically runs `terraform apply` before building and deploying the Go application.

### Required Jenkins Credentials

Add these credentials in Jenkins (Manage Jenkins → Manage Credentials):

1. **AWS_ACCESS_KEY_ID** (Secret text)
2. **AWS_SECRET_ACCESS_KEY** (Secret text)

These are injected into the pipeline via `withCredentials`.

## Variables

All variables have sensible defaults matching your current infrastructure:

- `aws_region`: eu-north-1
- `instance_type`: t3.micro
- `instance_name`: my-ec2
- `key_pair_name`: key-pair-my-ec2
- `security_group_name`: launch-wizard-1
- `vpc_id`: vpc-0c37569dc613b8d2a
- `subnet_id`: subnet-05d561f9d1ec007e2

Override via `terraform.tfvars`:

```hcl
aws_region        = "eu-north-1"
instance_type     = "t3.micro"
instance_name     = "my-ec2"
```

## State Management

Currently using local state (`terraform.tfstate`). For production, configure remote state in `backend.tf` using S3 + DynamoDB for locking.

## Troubleshooting

### Terraform init fails
- Ensure AWS credentials are configured
- Check IAM permissions for Terraform user

### terraform apply fails
- Verify security group rules don't conflict with existing resources
- Ensure key pair name is unique or already exists

### Jenkins pipeline fails
- Check Jenkins credentials are created and referenced correctly
- Verify AWS credentials have necessary IAM permissions
