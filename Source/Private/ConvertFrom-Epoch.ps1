function ConvertFrom-Epoch {
  param (
    [parameter(position=0)]
    $DateTime
  )
  [System.DateTimeOffset]::FromUnixTimeSeconds($DateTime).DateTime.ToString()
}