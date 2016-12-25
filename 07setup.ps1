# Ensure set-execution policy is correctly set
Set-ExecutionPolicy unrestricted -f
$ch = choco --version
if ($ch -eq $null) {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

$ch = git --version
if ($ch -eq $null){
    choco install git -y --force
    }

$ch = packer --version
if ($ch -eq $null){
    choco install  packer -y --force
    }