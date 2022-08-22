# Intune add Custom background for Teams

This Intune Win32 app uses the root of the script to copy files to the %appdata% folder of the specific user. 

## Requirements
- Requires Windows 10 Azure AD Joined devices managed with Microsoft Intune.
- Application must be deployed to run in **User** context.

* The app leverages the -AccountId parameter of the Connect-AzureAD cmdlet for Single Sign-On. Please note that this has only been tested on Azure AD Joined devices.

## How does it work?
1. Replace or update the files in the **Source\afbeelding** folders with one or more Background images you would like to use. For example upload your own and fetch them at %appdata%\Microsoft\Teams\Backgrounds\Uploads

2. Package the source folder with the Microsoft Win32 Content Prep Tool, for example:
`IntuneWinAppUtil.exe -c '.\Source' -s '.\Source\install.ps1' -o '.\Package'`

3. Deploy the .intunewin app with Microsoft Intune to your users!

## Deploying the Win32 app

### Install command
`PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "install.ps1"`

### Uninstall command. !! the uninstall deletes all .png files in de directory. Use wisely or change the script to your liking. 
`PowerShell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "uninstall.ps1"`

### Install behavior
User

## Detection rules
- Manually configure detection rules

Example:
 - Rule type: File
 - Path: %APPDATA%\Microsoft\Teams\Backgrounds\Uploads
 - File or folder: [name of your file].[extension]
 - Detection method: File or folder exists

