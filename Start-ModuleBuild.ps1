param(
  [version]$Version = '0.0.1'
)
#Requires -Module ModuleBuilder

$params = @{
  SourcePath                  = "$PSScriptRoot\Source\PS-Mosyle.psd1"
  CopyPaths                   = @("$PSScriptRoot\README.md", "$PSScriptRoot\Source\PS-Mosyle.nuspec")
  Version                     = $version
  UnversionedOutputDirectory  = $true
}
Build-Module @params