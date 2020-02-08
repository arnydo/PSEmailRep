function Get-EmailRep {
    <#
    .SYNOPSIS
    Query the EmailRep.io API for a report on an email address.
    
    .DESCRIPTION
    EmailRep uses hundreds of data points from social media profiles, professional networking sites,
    dark web credential leaks, data breaches, phishing kits, phishing emails, spam lists,
    open mail relays, domain age and reputation, deliverability,
    and more to predict the risk of an email address. https://emailrep.io/docs/#emailrep-alpha-api
    
    .PARAMETER EmailAddress
    Email address to be queried.
    
    .PARAMETER Summary
    When set to $true, a summary about the email address will be returned.

    .PARAMETER APIKey
    API key to authenticate against api.
    
    .PARAMETER Raw
    The original API response will be displayed. By default, the 'details' object is not a nested object.

    .PARAMETER UserAgent
    Specify the user agent of the web request.

    .PARAMETER APIStatus
    Return current query quota status. Daily or Monthly based on type of API key being used.
    
    .EXAMPLE
    Get-EmailRep -EmailAdress bill@microsoft.com

    email                      : bill@microsoft.com
    reputation                 : high
    suspicious                 : False
    references                 : 79
    blacklisted                : False
    malicious_activity         : False
    malicious_activity_recent  : False
    credentials_leaked         : True
    credentials_leaked_recent  : False
    data_breach                : True
    first_seen                 : 07/01/2008
    last_seen                  : 05/24/2019
    domain_exists              : True
    domain_reputation          : high
    new_domain                 : False
    days_since_domain_creation : 10354
    suspicious_tld             : False
    spam                       : False
    free_provider              : False
    disposable                 : False
    deliverable                : True
    accept_all                 : True
    valid_mx                   : True
    spoofable                  : False
    spf_strict                 : True
    dmarc_enforced             : True
    profiles                   : {twitter, vimeo, angellist, linkedin...}

    .EXAMPLE
    Get-EmailRep -EmailAdress bill@microsoft.com -Raw

    email      : bill@microsoft.com
    reputation : high
    suspicious : False
    references : 79
    details    : @{blacklisted=False; malicious_activity=False; malicious_activity_recent=False; credentials_leaked=True; credentials_leaked_recent=False; 
                data_breach=True; first_seen=07/01/2008; last_seen=05/24/2019; domain_exists=True; domain_reputation=high; new_domain=False;
                days_since_domain_creation=10354; suspicious_tld=False; spam=False; free_provider=False; disposable=False; deliverable=True; accept_all=True;     
                valid_mx=True; spoofable=False; spf_strict=True; dmarc_enforced=True; profiles=System.Object[]}

    .EXAMPLE
    Get-EmailRep -EmailAdress bill@microsoft.com -APIStatus

    Daily queries remaining: 92
    ...
    
    .EXAMPLE
    "bill@microsoft.com" | Get-EmailRep

    .EXAMPLE
    "bill@microsoft.com","john@microsoft.com" | Get-EmailRep | ft email,reputation,credentials_leaked

    email              reputation credentials_leaked
    -----              ---------- ------------------
    bill@microsoft.com high                     True
    john@microsoft.com high                     True
    
    .NOTES
    https://emailrep.io/docs/#emailrep-alpha-api
    #>
    

    [Cmdletbinding()]
    
    param(
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Email address to query'
        )]
        [ValidatePattern('^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$')]
        [string[]]
        $EmailAddress,

        [Parameter(
            HelpMessage = 'Return a summary property in the response'
        )]
        [switch]
        $Summary,

        [Parameter(
            Mandatory = $false
        )]
        [string]
        $ApiKey,

        [ValidatePattern('\w')]
        [string]$UserAgent = "PSEmailRep Powershell Module",

        [Parameter(
            HelpMessage = 'Return the raw response returned by the API'
        )]
        [switch]
        $Raw,
        [Parameter(
            HelpMessage = 'Return the current status of rate-limit quota'
        )]
        [switch]$APIStatus
    )

    begin {

        if (-not $ApiKey) {

            # Try and retrieve API Key stored in AppData
            try {
                Write-Verbose "Attempting to retrieve API Key from encrypted file."
                
                $APIKey = Get-EmailRepAPIKey

                Write-Verbose "API Key found!"

                if ($null -eq $ApiKey) {
                    Write-Warning "API Key is not set. Please set APIKey parameter or use 'Set-EmailRep -APIKey'"
                }
            }
            catch {
                Write-Warning "API Key not set and/or could not be retrieved. Please try again..."
                Write-Error $_.Exception.Message

                break
            }
        }

        $baseUrl = "https://emailrep.io"

        switch ($ApiKey) {
            $null {
                $headers = @{
                    "Accept" = "application/json"
                }
            }
            '' {
                $headers = @{
                    "Accept" = "application/json"
                }
            }
            default {
                $headers = @{
                    "Accept" = "application/json"
                    "Key"    = $ApiKey
                }
            }
        }

    }

    process {

        foreach ($Email in $EmailAddress) {

            if ($summary) {
                $queryUrl = "{0}/{1}?summary=true" -f $baseUrl, $Email
            }
            else {
                $queryUrl = "{0}/{1}" -f $baseUrl, $Email
            }

            try {

                $r = Invoke-WebRequest -Method GET -Uri $queryUrl -Headers $headers -UserAgent $UserAgent
                $j = $r.content | ConvertFrom-Json

                switch ( $r.StatusCode ) {
                    200 { $Status = 'OK' }
                    400 { $Status = 'Bad Request: Invalid email' }
                    401 { $Status = 'Unauthorized: invalid api key (for authenticated requests)' }
                    429 { $Status = 'Too Many Requests: too many requests. contact us for an api key' }
                }

                if ($r.StatusCode -ne 200) {
                    Write-Host $Status
                    throw
                }


                if ($raw) {
                    return $j
                }
                else {
                
                    $report = [PSCustomObject]@{
                        email      = $j.email
                        reputation = $j.reputation
                        suspicious = $j.suspicious
                        references = $j.references

                    }

                    if ($Summary) {
                        $report | Add-Member -MemberType NoteProperty -Name 'summary' -Value $j.summary
                    }

                    foreach ($p in $j.details.psobject.properties) {
                        $report | Add-Member -MemberType NoteProperty -Name $p.Name -Value $p.Value
                    }

                    if ($APIStatus) {
                        if ($r.headers['X-Rate-Limit-Daily-Remaining']) {
                            Write-Host -ForegroundColor Yellow "Daily queries remaining: $($r.headers['X-Rate-Limit-Daily-Remaining'])"
                        }
                        if ($r.headers['X-Rate-Limit-Monthly-Remaining']) {
                            Write-Host -ForegroundColor Yellow "Monthly queries remaining: $($r.headers['X-Rate-Limit-Daily-Remaining'])"
                        }
                    }

                    return $report
                }
            }
            catch {
                $_.Exception
            }
        }

    }

}