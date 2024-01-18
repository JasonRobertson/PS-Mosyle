param (
  [version]$Version = "1.0.0"
)

$command = Get-Command -Name "nuget" -CommandType Application

& $command[0] pack "$PSScriptRoot/Output/PS-Mosyle/PS-Mosyle.nuspec" -OutPutDirectory "$PSScriptRoot/Output/Nuget" -Version $Version