echo "Install AWS cli"

curl -o "/tmp/awscliv2.zip" "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
unzip /tmp/awscliv2.zip -d /tmp/awscliv2

bash /tmp/awscliv2/aws/install

/usr/local/bin/aws --version
