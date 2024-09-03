#Inventory Script for windows machines
#Using CIM cmdlets 

#Getting Computername and Domain info
$Info1 = Get-CimInstance -ClassName CIM_ComputerSystem

#Getting RAM Size
$PhysicalMemory = [Math]::Round(($Info1.TotalPhysicalMemory / 1Gb),2),' Gb' 
-join ""

#Getting OS Details
$OperatingSystem = Get-CimInstance -ClassName CIM_OperatingSystem 

#Getting Manufacturer Details
$Bios = Get-CimInstance -ClassName CIM_BIOSElement


#Getting Drive Details
$DriveDetails = Get-CimInstance -ClassName CIM_LogicalDisk | 
Select-Object -Property DeviceID,
@{Label='TotalSpace';Expression={[Math]::Round(($_.Size/1Gb),2),' Gb'-join ""}},
@{Label='AvailableSpace';Expression={[Math]::Round(($_.FreeSpace/1Gb),2),' Gb'-join ""}}

#Putting details together
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