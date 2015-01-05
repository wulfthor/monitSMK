##############################################################################
#
# NAME: 	check_supermicro.ps1
#
# AUTHOR: 	
# EMAIL: 	
#
# COMMENT:  Script to check supermicro status Nagios + NRPE/NSClient++
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
$pathToExec = "C:\adaptec\cmdline\arcconf\arcconf.exe"
$controller = 1



$logFile = "check_supermicro.log"

function LogLine(	[String]$logFile = $(Throw 'LogLine:$logFile unspecified'), 
    [String]$row = $(Throw 'LogLine:$row unspecified')) {
  $logDateTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    Add-Content -Encoding UTF8 $logFile ($logDateTime + " - " + $row) 
}

$resultString = C:\adaptec\cmdline\arcconf\arcconf.exe getconfig $controller | Select-String "optimal|sub-optimal|degraded"
[string[]] $nresultString = $resultString -replace "`n|`r"
$retVal = 1
$msg = ""

for ($i=0;$i -lt $nresultString.length;$i++) {
  $tmpString = $nresultString[$i].Split(":") 
    $finString = $tmpString[1] -replace '\s',''

    if ($finString.CompareTo("Optimal") -eq 0) {
      $retVal = 0  
    }

  if ($finString.CompareTo("Degraded") -eq 0) {
    $retVal = 2  
      Write-Host "CRITICAL - Degraded" + $tmpString[1]
      exit $returnStateCritical
  }

  if ($finString.CompareTo("Suboptimal") -eq 0) {
    $retVal = 1  
  }

  if ($finString.CompareTo("Sub-Optimal") -eq 0) {
    $retVal = 1  
  }	
}

if ($retVal -eq 0) {
  Write-Host "OK - no errors."
    exit $returnStateOK
}

if ($retVal -eq 1) {
  Write-Host "CRITICAL - Degraded."
    exit $returnStateWarning
}

Write-Host "UNKNOWN script state"
exit $returnStateUnknown
