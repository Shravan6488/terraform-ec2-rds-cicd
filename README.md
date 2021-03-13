# Infrasturcture and Automation of deplyoments

In this project, we are High Available infrastructure  with ec2 and RDS  And deployment setup with codepipeline.

![Architecture](/architecture.png)

## Prerequisites

Terraform ~> 0.12

<ul>
  <li>AWS Account</li>
  <li>IAM User with Access Key & Secret Key</li>
  <li>AWS CLI (<a target="_blank" href="https://aws.amazon.com/cli/">Download</a>)</li>
  <li>Terraform (<a target="_blank" href="https://www.terraform.io/downloads.html">Download</a>)</li>
</ul>
<strong>1. Configure local machine:</strong>
<ul>
  <li>Install AWS CLI</li>
  <li>Open terminal(linux/mac)/command prompt(windows)</li>
  <li>Run <code>aws configure</code></li>
  <li>Provide the access key, secret key and region as requested</li>
</ul>

<strong>2. Setup 2-tier Infrastructure:</strong>
<ul>
  <li>Unzip downloaded terraform file</li>
  <li>Add terraform executable file to your environment variable (Optional)</li>
  <li>Download all the files leaving .gitignore and README.md files. <strong>Note: You must generate your own private & public key</strong></li>
  <li>Open terminal(linux)/command prompt(windows)</li>
  <li>Run <code>terraform init</code> command</li>
  <li>Run <code>terraform apply</code> command. Provide <strong>yes</strong> as input when asked and hit enter</li>
</ul>

<h2><strong>Hurray!! Your infrastructure is now ready.</strong></h2>

## Cleanup

terraform destroy

## CICD

First need to run cloudformation template to setup codedeploy in the above AWS acount

you can setup by using below command
aws cloudformation create-stack
--stack-name test
--template-body https://raw.githubusercontent.com/shravan6488/Terraform-aws-CICD/cfn/test-master.json
--region eu-central-1
--disable-rollback --capabilities="CAPABILITY_IAM"
--parameters ParameterKey=KeyName,ParameterValue=YOURKEYPAIR
    ParameterKey=Branch,ParameterValue=master
    ParameterKey=BaseTemplateURL,ParameterValue=https://s3.amazonaws.com/YOURS3URL
    ParameterKey=GitHubUser,ParameterValue=YOURGITHUBUSER
    ParameterKey=GitHubToken,ParameterValue=YOURGITHUBTOKEN
    ParameterKey=DDBTableName,ParameterValue=YOURUNIQUEDDBTABLENAME
    ParameterKey=ProdHostedZone,ParameterValue=.YOURHOSTEDZONE

Here we check the environment variable $DEPLOYMENT_GROUP_NAME provided by the code deploy agent.

Add the codedeploy/appsec.yml in the codepipleine and trigger with Deployment Group Name.