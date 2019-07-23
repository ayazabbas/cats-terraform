Requirements
- Bash
- jq
- Zip
- Terraform 0.12.5
- awscli with configured credentials

Usage

Run deploy_cats.sh, you will be prompted to enter a version of the cats app.

The script willclone the cats repo, check-out the desired version and create
a zip archive. It will then run Terraform to create the Beanstalk Application
and the Serverless pipeline. Following the Terraform run, it will kick off
a state machine execution to run the serverless pipeline.