echo "Install Terraform"

#### The Terraform packages are signed using a private key controlled by HashiCorp, so in most situations the first step would be to configure your system to trust that HashiCorp key for package authentication.
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
#### After registering the key, you can add the official HashiCorp repository to your system:
apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" -y

apt-get -o DPkg::Lock::Timeout=-1 update -y
apt-get -o DPkg::Lock::Timeout=-1 install terraform=1.5.7-1 -y
echo "Exclude terraform package from apt update"
apt-mark hold terraform

echo "To resolve a complaint that it needs the GPG keys in gpg.d directory"
cp /etc/apt/trusted.gpg /etc/apt/trusted.gpg.d
