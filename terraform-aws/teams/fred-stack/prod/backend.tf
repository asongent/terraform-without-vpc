# terraform {
#   backend "s3" {
#     bucket         = "843825445314-us-east-1-terraform-state" # s3 remote state bucket name
#     key            = "state"                                  # path to state file should be unique per terraform directory
#     dynamodb_table = "fred-statefile-lock"
#     region         = "us-east-1" # region where s3 bucket was created
#   }
# }
