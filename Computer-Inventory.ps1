#Inventory Script for windows machines
#Using CIM cmdlets
$Global:ErrorActionPreference='stop' 
try{

#function for logging
[string]$Date=get-Date -Format MM/dd/yyyy/HH/mm/ss
[string]$Global:Path="C:\Users\HOME SYPR\Desktop\Test_$Date.log"
function write-log {
	param (
		[string]$Message,
	    [string]$path = $Path
		)
	
Write-Output "$(get-date) $Message" | Out-File -FilePath $path -Append

}
#Getting Computername and Domain info
write-log -Message "Getting Computername and Domain info" -Path $Path
$Info1 = Get-CimInstance -ClassName CIM_ComputerSystem

#Getting RAM Size
write-log -Message "Getting RAM Size"
$PhysicalMemory = [Math]::Round(($Info1.TotalPhysicalMemory / 1Gb),2),
' Gb'-join ""

#Getting OS Details
write-log -Message "Getting OS Details"

$OperatingSystem = Get-CimInstance -ClassName CIM_OperatingSystem 

#Getting Manufacturer Details
write-log -Message "Getting Manufacturer Details"
$Bios = Get-CimInstance -ClassName CIM_BIOSElement


#Getting Drive Details
write-log -Message "Getting Drive Details"
$DriveDetails = Get-CimInstance -ClassName CIM_LogicalDisk | 
Select-Object -Property DeviceID,
@{Label='TotalSpace Gb';Expression={[System.Math]::Round(($_.Size/1Gb),2)}},
@{Label='AvailableSpace Gb';Expression={[System.Math]::Round(($_.Freespace/1Gb),2)}}

#Putting details together
write-log -Message "Putting details together"
$ComputerDetails = [PSCustomObject]@{
ComputerName = $Info1.Name
Domain = $Info1.Domain
OperatingSystem = $OperatingSystem.Caption
Version = $OperatingSystem.Version
RAM = $PhysicalMemory
LogicalDrives = $DriveDetails
Manufacturer = $Bios.Manufacturer
SerialNumber = $Bios.SerialNumber
}

#final Inventory
$ComputerDetails

#Export as a specific format or out this to a file to generate reports
[string]$Csvdate=get-Date -Format MM/dd/yyyy/HH/mm/ss

$ComputerDetails | 
Export-csv -Path "C:\users\HOME SYPR\Desktop\Inventory_$Csvdate.csv" -NoTypeInformation -NoClobber 

write-log -Message "Report generated and saved"
}
catch [System.Exception]
{
	write-log -Message $_.exception.message
    write-log -Message $_.scriptstacktrace
	write-log -Message "Fix errors, re-run the script"
}
finally{
	Write-Output " Script excecution complete $(get-date), check logfile"
}