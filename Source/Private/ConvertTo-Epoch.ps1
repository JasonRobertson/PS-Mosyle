function ConvertTo-Epoch {
  param (
    [parameter(position=0)]
    $DateTime
  )
  [System.DateTimeOffset]::new($DateTime).ToUnixTimeSeconds()
}