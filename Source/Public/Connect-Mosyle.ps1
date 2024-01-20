<#
  .Synopsis
    Connect-Mosyle is used to establish the connection to the  Mosyle.
  .DESCRIPTION
    Connect-Mosyle is used to establish the connection to the  Mosyle. Requires an API Token generated within Mosyle Admin Portal.
  .EXAMPLE
    PS C:\> Connect-Mosyle

    cmdlet Connect-Mosyle at command pipeline position 1
    Supply values for the following parameters:
    Credential
    User: svc_account@example.com
    Password for user svc_account@example.com: *************************

    AccessToken: ***************************
    Sucessfully connected to Mosyle

    Email  : svc_account@example.com
    UserID : 4837209
  .EXAMPLE
    PS C:\> $mosyleCredential = Get-Credential

    PowerShell credential request
    Enter your credentials.
    User: svc_account@example.com
    Password for user svc_account@example.com: *******

    PS C:\> $mosyleAccessToken = Get-Credential

    PowerShell credential request
    Enter your credentials.
    User: accessToken
    Password for user accessToken: *******

    PS C:\> Connect-Mosyle -Credential $mosyleCredential -AccessToken $mosyleAccessToken.Password
    Sucessfully connected to Mosyle

    Email  : svc_account@example.com
    UserID : 4837209
#>
function Connect-Mosyle {
  [CmdletBinding()]
  Param(
    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [PSCredential]$Credential,
    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [pscredential]$AccessToken
  )
  begin {}
  process {
    $uri            = 'https://businessapi.mosyle.com/v1'
    $body           = [hashtable]::new()
    $body.email     = $credential.UserName
    $body.password  = $credential.GetNetworkCredential().Password

    $headers              = [hashtable]::new()
    $headers.Accept       = 'application/json'
    $headers.accessToken  = $AccessToken.GetNetworkCredential().Password

    $restMethod                         = [hashtable]::new()
    $restMethod.URI                     = "$uri/login"
    $restMethod.Body                    = $body | ConvertTo-Json
    $restMethod.Method                  = 'POST'
    $restMethod.Headers                 = $headers
    $restMethod.ContentType             = 'application/json'
    $restMethod.ErrorAction             = 'STOP'
    $restMethod.ResponseHeadersVariable = 'apiResponseHeaders'

    try {
      $apiResponse = Invoke-RestMethod @restMethod
    }
    catch {
      Write-Host -ForegroundColor Red 'Failed to connect to Mosyle'
      $message = ($PSItem.ErrorDetails.Message | ConvertFrom-Json).error
      $errorRecord = [System.Management.Automation.ErrorRecord]::new(
        [exception]::new($message),
        'ErrorID',
        [System.Management.Automation.ErrorCategory]::NotSpecified,
        'Mosyle'
      )
      $pscmdlet.ThrowTerminatingError($errorRecord)
    }
    if ($apiResponse -and $apiResponseHeaders) {
      Write-Host -ForegroundColor Green -Message "Sucessfully connected to Mosyle"
      $script:connectionMosyle = [pscustomobject][ordered]@{
        Uri                   = $uri
        Email                 = $apiResponse.email
        UserID                = $apiResponse.UserID
        AuthToken             = [pscredential]::new(' ',(ConvertTo-SecureString -AsPlainText -string $($apiResponseHeaders.Authorization) -Force))
        AuthTokenExpiration   = [DateTime]::ParseExact($apiResponseHeaders.Expires.TrimEnd(' GMT'), "ddd, dd MMM yyyy HH:mm:ss", [System.Globalization.CultureInfo]::InvariantCulture).ToString('s')
        AccessToken           = $AccessToken
      }
      $connectionMosyle | Format-List Email, UserID, AuthTokenExpiration
    }
  }
  end {}
}
