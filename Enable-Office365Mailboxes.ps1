# Author: Peter Schmidt (psc@globeteam.com) - Blog: www.msdigest.net
# This script Enable Remote Mailboxes (Office 365 Mailboxes) in the Exchange on-premise (Hybrid), if for some reason mailboxes have been created 
# in Office 365 and are missing in the local Hybrid environment and needed for local administration tasks.
# Last updated: 2017.01.26
# Version: 0.1
# Requirements: Exchange Server modules for PowerShell 

#Import Modules
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;

#Identity information gotten by connect to Office 365 and run this command: get-mailbox | ft Primary*,ExchangeGUID > identity.csv
#The Identity file syntax should look like this:
#PrimarySmtpAddress,ExchangeGuid,                
#abc@FABRIKAM.com,1234b12-a12d-1234-9795-43212d54321c,

$csv = import-csv c:\scripts\identity.csv

ForEach ($item in $csv)
{
    $StrPrimary = $item.PrimarySmtpAddress
    $StrGUID = $item.ExchangeGuid 

#Write-Host $_
Write-Host "Primary: " $StrPrimary
Write-Host "GUID: " $StrGUID  
$AliasName=$StrPrimary.Split("@")[0]
Write-Host "Email Alias: " $AliasName
#Set the Tenant name here, change FABRIKAM to your tenant name:  
$RemoteRtAdr = "$AliasName@FABRIKAM.mail.onmicrosoft.com"
Write-Host "Email Alias: " $RemoteRtAdr  

Write-host -ForegroundColor Cyan "---------------------------------------------------------------------------"
Write-host -ForegroundColor Cyan "Set Office 365 Remote Mailbox and reconnect them to existing O365 Mailboxes"
Write-host -ForegroundColor Cyan "---------------------------------------------------------------------------"

Enable-RemoteMailbox -Identity $StrPrimary -RemoteRoutingAddress $RemoteRtAdr
Set-RemoteMailbox -Identity $StrPrimary -ExchangeGUID $StrGUID
}
