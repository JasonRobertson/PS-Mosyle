function Disconnect-Mosyle {
  try{
    if ($script:connectionMosyle) {
      Remove-Variable connectionMosyle -Scope Script -ErrorAction Stop
    }
    else {
      Write-Warning 'No Mosyle session found.'
    }
  }
  catch {
    Write-Error 'Failed to disconnect Mosyle session. Please close the terminal to forcefully close the session.'
  }
}