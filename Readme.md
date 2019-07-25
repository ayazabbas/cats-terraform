Design documentation: https://docs.google.com/document/d/1wwOX-auBPwnyH8bhXa8eezz4OT_MA8bOZxkdSI-sHdE/edit?usp=sharing

## Requirements
- Bash
- jq
- Zip
- Terraform 0.12.5
- AWS account with S3 bucket for Terraform state storage and DynamoDB table for state locking (edit [main.tf](main.tf) accordingly)
- awscli with configured credentials (see https://www.terraform.io/docs/providers/aws/index.html for more info on credentials)

## Usage

- Run `bash deploy_cats.sh`, you will be prompted to enter a version of the cats app.
    - The script will clone the cats repo, check-out the desired version and create a zip archive.
    - It will then run Terraform to create the Beanstalk Application and the Serverless pipeline.
    - Following the Terraform run, it will kick off a state machine execution to run the serverless pipeline.
    - To deploy a new version, run the script again and enter the desired version.

## Cleanup

- You will have to manually terminate any running Beanstalk environments.
- You can then run `terraform destroy` and enter the last deployed app version when prompted.
- If you are finished with the pipeline completely, you can go into the AWS console and delete the backend S3 bucket and DynamoDB table.