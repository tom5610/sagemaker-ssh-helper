#!/bin/sh

#######################
# comment out for now and only use for blank setup while running under '/root' folder
# download sagemaker-ssh-helper package 
# if [ ! -d "/root/sagemaker-ssh-helper" ]; then
#   git clone https://github.com/aws-samples/sagemaker-ssh-helper.git
# fi

# # installation
# cd sagemaker-ssh-helper
#########################

# activate the environment
eval "$(conda shell.bash hook)"
conda activate base

pip install -q .

# ssh ide configuration
sm-ssh-ide configure

# default VNC password setup
VNC_PASSWORD="Ap456wct"  # replace with your pasword
mkdir -p ~/.vnc
echo "$VNC_PASSWORD" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Get caller identity
caller_id=$(aws sts get-caller-identity --query 'UserId' --output text)
echo caller id - $caller_id

# initialize ssm
sm-ssh-ide init-ssm $caller_id

# start ide
sm-ssh-ide start

# list the KernalGateway app id
echo "KernalGateway App ID"
cat /opt/ml/metadata/resource-metadata.json | grep -o '"ResourceName":"[^"]*"'

# start ssm agent for IDE.
sm-ssh-ide ssm-agent