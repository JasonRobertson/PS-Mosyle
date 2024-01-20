function Lock-MosyleDevice {
  param(
    [parameter(Mandatory, Position=0)]
    [string]$Identity,
    [parameter(Mandatory, Position=1)]
    [ValidateRange(6,6)]
    [int32]$PinCode,
    [string]$LockMessage
  )
  $device = Get-MosyleDevice -Identity $Identity -DeviceIDOnly

  $mosyleAPI                   = [hashtable]::new()
  $mosyleAPI.Body              = [hashtable]::new()
  $mosyleAPI.Body.pincode      = $PinCode
  $mosyleAPI.Body.devices      = $device
  $mosyleAPI.Body.operation    = 'lock_device'
  $mosyleAPI.Body.lockmessage  = $message
  $mosyleAPI.Method            = 'POST'
  $mosyleAPI.Endpoint          = 'devices'
  Invoke-MosyleAPI @mosyleAPI
}