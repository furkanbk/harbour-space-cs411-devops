# Terraform Backend Configuration
# Uncomment and configure to use remote state (recommended for production)
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "harbour-space/terraform.tfstate"
#     region         = "eu-north-1"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }

# For now, state is stored locally
