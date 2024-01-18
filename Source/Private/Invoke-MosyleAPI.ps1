function Invoke-MosyleAPI {
  [CmdletBinding()]
  Param(
    [ValidateSet('GET', 'PATCH', 'POST', 'PUT', 'DELETE')]
    [string]$Method='GET',
    [Parameter(Mandatory)]
    [string]$Endpoint,
    $Body,
    [switch]$All
  )
  if ($mosyleURI = (Get-MosyleConnection).Uri) {
    $restMethod                       = [hashtable]::new()
    $restMethod.Uri                   = "$mosyleURI/$endpoint"
    $restMethod.Body                  = switch ($method -match '^GET|DELETE$' ) {
                                          True  {$body}
                                          False {$body | ConvertTo-Json -Depth 100}
                                        }
    $restMethod.Method                = $method
    $restMethod.ContentType           = 'application/json'
    $restMethod.Headers               = [hashtable]::new()
    $restMethod.Headers.Accept        = 'application/json'
    $restMethod.Headers.accessToken   = [pscredential]::new(' ',$connectionMosyle.AccessToken).GetNetworkCredential().password
    $restMethod.Headers.Authorization = $connectionMosyle.AuthToken.GetNetworkCredential().password
    $restMethod.FollowRelLink         = $all
    try {
      $response = Invoke-RestMethod @restMethod

      foreach ($entry in $response){
        $entry.response
      }
    }
    catch {
      $message = ($PSItem.ErrorDetails.Message | ConvertFrom-Json).error
      $errorRecord = [System.Management.Automation.ErrorRecord]::new(
        [exception]::new($message),
        'ErrorID',
        [System.Management.Automation.ErrorCategory]::NotSpecified,
        'Mosyle'
      )
      $pscmdlet.ThrowTerminatingError($errorRecord)
    }
  }
}