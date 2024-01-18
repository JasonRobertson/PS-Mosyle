function Get-MosyleConnection {
  if ($null -eq $connectionMosyle.Uri) {
    Write-Host -ForegroundColor Red 'Connection to Mosyle has not been established.'
    Write-Host -ForegroundColor Yellow 'Run Connect-Mosyle to establsih a session with Mosyle'
    break
  }
  else {
    $connectionMosyle| Select-Object -ExcludeProperty AccessToken, AuthToken
  }
}