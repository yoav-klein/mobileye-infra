
# Infrastructure Repository
---

This repository holds the Infrastructure as Code for provisioning and configuring
the required resources for the assignment.

This divides to 2 sections, with a directory for each: `application` and `ci`

### Application

This directory holds Terraform code to provision the resources that are needed
to run the application. This includes:
1. Application Load Balancer
2. ECR repository
3. ECS cluster + service
4. 2 EC2 instances on which the ECS will run tasks

### CI

This directory holds Terraform and Ansible code to provision and configure the EC2
instance on which the Jenkins server will run.

## Usage

#### Prerequisites

First, you must export the authentication environment variables:
```
export AWS_ACCESS_KEY_ID=<ACCESS_KEY>
export AWS_SECRET_ACCESS_KEY=<SECRET_ACCESS_KEY>
```

We'll be using Docker to run Terraform and Ansible, so make sure you have Docker installed.
You'll also need a key pair, so generate one as such (keep the name `key`):
```
$ ssh-keygen -t rsa -f key
```


### Application

1. Provision the resources. cd to the `application` directory, copy the `key.pub` file to this directory, and run:
```
../run_tf.sh apply -auto-approve
```

This will output 2 important details:
1. The DNS name of the load balancer for the application. Save it for later use.
2. The URL of our ECR repository. Save it also for later use.

### CI


1. Provision the resources. cd to the `terraform` directory, copy the `key.pub` to this directory, and run:
```
$ ../../run_tf.sh apply -auto-approve
```

This will output the DNS of our Jenkins instance. Save it.

2. Install Jenkins. cd to the `ansible` directory, copy the `key` file to this directory, and run:
```
$ ./run.sh
```

This will run Jenkins as a Docker container in the above provisioned instance. Note that ansible
will output the `initialAdminPassword` - Save it.

3. Configure Jenkins. 
a. Browse to our Jenkins instance using the DNS name from step 1. 

b. Enter the initialAdminPassword from step 2.

c. Install the recommended plugins and create a user.

d. Configure credentials to our AWS account for the pipeline to use.

* Go to the Credentials Store in Jenkins
* Add a new credential of type AWS Credentials, with ID `aws_account`
* Fill in the Access Key ID and Secret Key.

e. Create a pipeline, and configure it to use the repository URL: `https://github.com/yoav-klein/mobileye-application`

We'll need to edit the registry URL in the Jenkinsfile, which is in this other repository. Further details
there.


## Known Issues

1. It is considered a best practice to use the `awsvpc` network mode. But for some reason, using EC2 launch type
with the `awsvpc` didn't work. See https://stackoverflow.com/questions/74255478/how-to-run-ecs-task-on-ec2-with-awsvpc
So currently we use the Bridge network mode.


