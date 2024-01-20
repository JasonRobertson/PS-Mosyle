function Get-MosyleDevice {
  [CmdletBinding(DefaultParameterSetName='Identity')]
  param(
    [parameter(ParameterSetName='Identity')]
    [string]$Identity,
    [validateSet('macOS','iOS','tvOS')]
    [string]$OS = 'macOS',
    [string[]]$OSVersion,
    [parameter(ParameterSetName='SerialNumber')]
    [string[]]$SerialNumber,
    [string[]]$Model,
    [datetime]$EnrollDate,
    [datetime]$UpdateDate,
    [string[]]$Tags,
    [switch]$DeviceIDOnly,
    [ValidateRange(1,20000)]
    [int]$Limit = 5000
  )
  begin {
    $options = [hashtable]::new()
    $options.os = switch ($OS) {
      macOS {'mac'}
      iOS   {'ios'}
      tvOS  {'tvos'}
      default {'mac'}
    }
    $options.page_size = $limit

    if ($tags)          { $options.tags            = $tags}
    if ($model)         { $options.models          = $model}
    if ($identity)      { $options.deviceudids     = $identity}
    if ($osVersion)     { $options.osversions      = $OSVersion}
    if ($serialNumber)  { $options.serial_numbers  = $serialNumber}
    if ($deviceIDOnly)  { $options.only_deviceudid = $DeviceIDOnly}
    if ($enrollDate)    {
                          $options.enolldate_end    = ConvertTo-Epoch $enollDate
                          $options.enolldate_start  = ConvertTo-Epoch $enollDate
    }
    if ($updateDate)    {
                          $options.updatedate_end    = ConvertTo-Epoch $updateDate
                          $options.updatedate_start  = ConvertTo-Epoch $updateDate
    }

    $body               = [hashtable]::new()
    $body.options       = $options
    $body.operation     = 'list'

    $mosyleAPI          = [hashtable]::new()
    $mosyleAPI.Body     = $body
    $mosyleAPI.Method   = 'POST'
    $mosyleAPI.Endpoint = 'devices'
  }
  process {
    $apiResponse = (Invoke-MosyleAPI @mosyleAPI).devices
    if ($apiResponse.count -gt 0) {
      foreach ($entry in $apiResponse) {
        if ($DeviceIDOnly) { $entry }
        else {
          # Some properites are not converted from JSON via Invoke-RestMethod. If values are present they are convertfrom-Json.
          if ($entry.OSUpdateSettings)        {$entry.OSUpdateSettings        = $entry.OSUpdateSettings | ConvertFrom-Json }
          if ($entry.ActiveManagedUsers)      {$entry.ActiveManagedUsers      = $entry.ActiveManagedUsers | ConvertFrom-Json}
          if ($entry.AutoSetupAdminAccounts)  {$entry.AutoSetupAdminAccounts  = $entry.AutoSetupAdminAccounts | ConvertFrom-Json}
          if ($entry.ManagementStatus)        {$entry.ManagementStatus        = $entry.ManagementStatus | ConvertFrom-Json }
          if ($entry.OSUpdateStatus)          {$entry.OSUpdateStatus          = $entry.OSUpdateStatus | ConvertFrom-Json}
          if ($entry.AvailableOSUpdates)      {$entry.AvailableOSUpdates      = $entry.AvailableOSUpdates | ConvertFrom-Json}

          #Convert Mosyle Date_* time value to sortable Date/Time pattern value.
          if ($entry.date_info)               {$entry.date_info           = ConvertFrom-Epoch $entry.date_info}
          if ($entry.date_app_info)           {$entry.date_app_info       = ConvertFrom-Epoch $entry.date_app_info}
          if ($entry.date_last_beat)          {$entry.date_last_beat      = ConvertFrom-Epoch $entry.date_last_beat}
          if ($entry.date_last_push)          {$entry.date_last_push      = ConvertFrom-Epoch $entry.date_last_push}
          if ($entry.date_muted)              {$entry.date_muted          = ConvertFrom-Epoch $entry.date_muted}
          if ($entry.date_media_info)         {$entry.date_media_info     = ConvertFrom-Epoch $entry.date_media_info}
          if ($entry.date_profiles_info)      {$entry.date_profiles_info  = ConvertFrom-Epoch $entry.date_profiles_info}
          if ($entry.date_printers)           {$entry.date_printers       = ConvertFrom-Epoch $entry.date_printers}
          if ($entry.date_lastlogin)          {$entry.date_lastlogin      = ConvertFrom-Epoch $entry.date_lastlogin}
          if ($entry.date_checkin)            {$entry.date_checkin        = ConvertFrom-Epoch $entry.date_checkin}
          if ($entry.date_enroll)             {$entry.date_enroll         = ConvertFrom-Epoch $entry.date_enroll}
          if ($entry.date_checkout)           {$entry.date_checkout       = ConvertFrom-Epoch $entry.date_checkout}
          if ($entry.date_kinfo)              {$entry.date_kinfo          = ConvertFrom-Epoch $entry.date_kinfo}
          $entry
        }
      }
    }
    else {
      $message = If ($Identity) {
        "No Device ID matched $identity"
      }
      elseif ($SerialNumber) {
        "No SerialNumber matched $serialNumber"
      }
      else {
        "No devices found"
      }
      Write-Warning $message
    }
  }
  end {}
}