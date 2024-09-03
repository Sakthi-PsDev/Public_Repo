#Inventory Script for windows machines
#Using CIM cmdlets 

#Getting Computername and Domain info
$Info1 = Get-CimInstance -ClassName CIM_ComputerSystem

$MachineName = $Info1.Name

$DomainName = $Info1.Domain

$PhysicalMemory = [Math]::Round(($Info1.TotalPhysicalMemory / 1Gb),2),' Gb' 
-join ""

#Getting Drive Details
