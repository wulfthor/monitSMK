##############################################################################
#
# NAME: 	check_mailq.ps1
#
# AUTHOR: 	
# EMAIL: 	
#
# COMMENT:  
#
#			Return Values for NRPE:
#			Status optimal - OK (0)
#			Status suboptimal - WARNING (1)
#			Status degraded - CRITICAL (2)
#
##############################################################################

$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3



if ( (Get-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.E2010 -ErrorAction:SilentlyContinue) -eq $null)
{
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
}

$NagiosStatus = "0"


  
$resultCount = Get-Queue -Server MAIL-01 | Measure-Object | Select-Object -expand Count
[string[]]$resultHop = Get-Queue -Server MAIL-01 | Select-Object Identity,NextHopDomain,MessageCount

$NagiosStatus = "0"
$NagiosDescription = ""
$NagiosPerfData = ""

$NagiosDescription = Get-Queue -Server MAIL-01 | ForEach-Object { Write-Output -Message " "  $_.Identity " " $_.MessageCount  " msgto "  $_.NextHopDomain " "
}

# Output, what level should we tell our caller?
$NagiosPerfData = "|queue=" + $resultCount + ";15;20;0"

if ($resultCount -gt "20") 
{
	Write-Host "CRITICAL: " $NagiosDescription" "$NagiosPerfData
  NagiosStatus = "2"
} 
elseif ($resultCount -gt "15")
{
	Write-Host "WARNING: " $NagiosDescription" "$NagiosPerfData
  $NagiosStatus = "1"
} 
else 
{
	Write-Host "OK: All mail queues " $NagiosDescription " within limits. "$NagiosPerfData
}

exit $NagiosStatus		
