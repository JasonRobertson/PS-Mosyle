function Restart-MosyleDevice {
  param(
    [parameter(Mandatory, Position=0)]
    [string]$Identity
  )
  $device = Get-MosyleDevice -Identity $Identity -DeviceIDOnly

  $mosyleAPI                   = [hashtable]::new()
  $mosyleAPI.Body              = [hashtable]::new()
  $mosyleAPI.Body.devices      = $device
  $mosyleAPI.Body.operation    = 'restart_devices'
  $mosyleAPI.Body.lockmessage  = $message
  $mosyleAPI.Method            = 'POST'
  $mosyleAPI.Endpoint          = 'devices'
  Invoke-MosyleAPI @mosyleAPI
}