#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILED $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
    exit 1 # you can give other than 0
else
    echo "You are root user"
fi # fi means reverse of if, indicating condition end

# Installing yum-utils
yum install -y yum-utils
VALIDATE $? "Installed yum-utils"

# Adding centos user to docker group
usermod -aG docker centos
VALIDATE $? "Added centos user to docker group"
echo -e "$R Logout and login again $N"

# Installing kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl
VALIDATE $? "Kubectl installation"

# Installing eksctl
curl --silent --location "https://github.com/eksctl-io/eksctl/releases/download/v0.88.0/eksctl_Linux_amd64.tar.gz" -o eksctl_Linux_amd64.tar.gz
tar -xvzf eksctl_Linux_amd64.tar.gz
sudo mv eksctl /usr/local/bin
eksctl version


# Installing kubens
sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
VALIDATE $? "kubens installation"

