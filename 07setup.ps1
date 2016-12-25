# Ensure set-execution policy is correctly set
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco --version
choco install git -y --force
choco install  packer -y --force
