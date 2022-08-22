# Win32 app runs PowerShell in 32-bit by default. AzureAD module requires PowerShell in 64-bit, so we are going to trigger a rerun in 64-bit.
if ($env:PROCESSOR_ARCHITEW6432 -eq "AMD64") {
    try {
        & "$env:WINDIR\SysNative\WindowsPowershell\v1.0\PowerShell.exe" -File $PSCommandPath
    }
    catch {
        throw "Failed to start $PSCommandPath"
    }
    exit
}

Start-Transcript -Path "$($env:TEMP)\IntuneFileforTeamsBackground-log.txt" -Force

# Install NuGet Package Provider
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Scope CurrentUser -Force

# Install AzureAD module to retrieve the user information
Install-Module -Name AzureAD -Scope CurrentUser -Force -AllowClobber

# Leverage Single Sign-on to sign into the AzureAD PowerShell module
$userPrincipalName = whoami -upn
Connect-AzureAD -AccountId $userPrincipalName

# Get the user information to update the signature
$userObject = Get-AzureADUser -ObjectId $userPrincipalName

# Create signatures folder if not exists
if (-not (Test-Path "$($env:APPDATA)\Microsoft\Teams\Backgrounds\Uploads")) {
    $null = New-Item -Path "$($env:APPDATA)\Microsoft\Teams\Backgrounds\Uploads" -ItemType Directory
}

# Get all signature files
$Files = Get-ChildItem -Path "$PSScriptRoot\afbeelding"

foreach ($File in $Files) {
    if ($File.Name -like "*.png") {
        Copy-Item "$PSScriptRoot\afbeelding\*.png" -Destination "$($env:APPDATA)\Microsoft\Teams\Backgrounds\Uploads"

    }
}

Stop-Transcript