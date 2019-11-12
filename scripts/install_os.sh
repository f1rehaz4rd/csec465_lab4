sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
sudo add-apt-repository "deb [arch=amd64] https://osquery-packages.s3.amazonaws.com/deb deb main"
sudo apt-get update
sudo apt-get install osquery

echo "OSQuery Installed"