# LocalStack with DIND

The repository covers the following:

1) API Gateway that serves a Lambda function.

2) An HTTP endpoint that serves a file from an S3 bucket. 

3) Two EC2 instances, one with public subnet and one with private subnet based on the same VPC.

4) Localstack dependent on [Docker-in-Docker](https://hub.docker.com/_/docker) container socket.

Make sure you have awscli configured and awslocal setup and set your LocalStack Auth Token in the `.env` file.

## Prepare the environment

Build Docker images locally and run detached

    docker compose up --build -d

Create the S3 bucket that will hold the TF state

    ./localstack/aws/buckets.sh

Then, enter the worker container

    docker exec -it tfrunner-cnt /bin/bash

Go to the bind mount folder containing project files.

    cd /mnt/terraform

Initialize the backend state file on S3

    terraform init -upgrade \
        -backend-config=endpoint="http://localstack:4566" \
        -backend-config=access_key="myrootaccesskeyid" \
        -backend-config=secret_key="myrootsecretaccesskey" \
        -backend-config=bucket="platform-state-local" \
        -backend-config=key="tfstate.json" \
        -backend-config=region="eu-west-3" \
        -backend-config=skip_credentials_validation=true \
        -backend-config=skip_metadata_api_check=true \
        -backend-config=skip_region_validation=true \
        -backend-config=force_path_style=true

Create Terraform plan

    terraform plan -out .terraform/tf-plan.out
    
Apply the plan

    terraform apply ".terraform/tf-plan.out"

You should see a URL to test the Api Gateway endpoint similar to the following

    curl http://localstack:4566/restapis/<id>/test/_user_request_/ -vv

And the API will reply `Cheers from AWS Lambda!!`.

You will also see another URL for the S3 file endpoint

    curl -X GET http://localstack:4566/file-bucket/data.txt -vv

And the output will be `Hello, from file data.`.

If you would like to destroy the deployed stack you can do so by using the `--destory` flag with terraform plan then apply as follows

    terraform plan -out .terraform/tf-plan.out --destroy
    terraform apply ".terraform/tf-plan.out"

Exit the container by entering `exit` and destory by

    docker compose down -v


## Prepare the environment in DIND

Build Docker images locally and run detached

    docker compose -f docker-compose-dind.yml up -d

Then, enter the dind container

    docker exec -it dind /bin/sh

Install the AWS Cli

    apk add aws-cli

Go to the mount folder containing project files.

    cd /mnt

Build Docker images and run detached

    docker compose up --build -d

Create the S3 bucket that will hold the TF state

    aws --endpoint-url=http://localhost:4566 s3 mb s3://platform-state-local

Then, enter the worker container

    docker exec -it tfrunner-cnt bash -l

Go to the bind mount folder containing project files.

    cd /mnt/terraform

Initialize the backend state file on S3

    terraform init -upgrade \
        -backend-config=endpoint="http://localstack:4566" \
        -backend-config=access_key="myrootaccesskeyid" \
        -backend-config=secret_key="myrootsecretaccesskey" \
        -backend-config=bucket="platform-state-local" \
        -backend-config=key="tfstate.json" \
        -backend-config=region="eu-west-3" \
        -backend-config=skip_credentials_validation=true \
        -backend-config=skip_metadata_api_check=true \
        -backend-config=skip_region_validation=true \
        -backend-config=force_path_style=true

Create Terraform plan

    terraform plan -out .terraform/tf-plan.out
    
Apply the plan

    terraform apply ".terraform/tf-plan.out"

You should see a URL to test the Api Gateway endpoint similar to the following

    curl http://localstack:4566/restapis/<id>/test/_user_request_/ -vv

And the API will reply `Cheers from AWS Lambda!!`.

You will also see another URL for the S3 file endpoint

    curl -X GET http://localstack:4566/file-bucket/data.txt -vv

And the output will be `Hello, from file data.`.

Exit the container by entering `exit` and destory by

    docker compose down -v

Now exit the DIND container by entering `exit` and destory by

    docker compose -f docker-compose-dind.yml down -v
