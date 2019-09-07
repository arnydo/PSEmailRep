function New-EmailRep {
    <#
    .SYNOPSIS
    Submit a new report to EmailRep.io
    
    .DESCRIPTION
    Reports an email address. Date of malicious activity defaults to the current time unless otherwise specified.
    
    .PARAMETER Email
    Email address being reported.
    
    .PARAMETER Tags
    Tags that should be applied.

    account_takeover - Legitimate email has been taken over by a malicious actor
    bec - Business email compromise, whaling, contact impersonation/display name spoofing
    brand_impersonation - Impersonating a well-known brand (e.g. Paypal, Microsoft, Google, etc.)
    browser_exploit - The hosted website serves an exploit
    credential_phishing - Attempting to steal user credentials
    generic_phishing - Generic phishing, should only be used if others don't apply or a more specific determination can't be made or would be too difficult
    malware - Malicious documents and droppers. Can be direct attachments, indirect free file hosting sites or droppers from malicious websites
    scam - Catch-all for scams. Sextortion, payment scams, lottery scams, investment scams, fake bank scams, etc.
    spam - Unsolicited spam or spammy behavior (e.g. forum submissions, unwanted bulk email)
    spoofed - Forged sender email (e.g. the envelope from is different than the header from)
    task_request - Request that the recipient perform a task (e.g. gift card purchase, update payroll, send w-2s, etc.)
    threat_actor - Threat actor/owner of phishing kit
    
    .PARAMETER Description
    Additional information and context.
    
    .PARAMETER Timestamp
    When this activity occurred in UTC. Defaults to now().
    
    .PARAMETER Expires
    Parameter description
    
    .PARAMETER ApiKey
    Number of hours the email should be considered risky (suspicious=true and blacklisted=true in the QueryResponse). Defaults to no expiration unless account_takeover tag is specified, in which case the default is 14 days.
    
    .PARAMETER Force
    Submit report without confirmation prompt.

    .EXAMPLE
    New-EmailRep -Email test_emailrep_xxxxx@foobar.com -Description "Business email compromise" -Tags bec -Force

    status 
    ------ 
    success
    
    .NOTES
    https://emailrep.io/docs/#report-an-email-address
    #>
     

    [Cmdletbinding(SupportsShouldProcess = $true, ConfirmImpact = 'High')]
    
    param(
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Email address to query'
        )]
        [ValidatePattern('^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$')]
        [string[]]
        $Email,

        [Parameter(
            Mandatory = $true,
            HelpMessage = 'Tags that should be applied'
        )]
        [ValidateSet(
            'account_takeover', 'bec', 'brand_impersonation', 'browser_exploit', 'credential_phishing', 'generic_phishing', 'malware', 'scam', 'spam', 'spoofed', 'task_request', 'threat_actor'
        )]
        [string[]]
        $Tags,

        [Parameter(
            HelpMessage = 'Additional information and context'
        )]
        [string]
        $Description,

        [Parameter(
            HelpMessage = 'When this activity occurred in UTC. Defaults to now().'
        )]
        [int]
        $Timestamp = [int][double]::Parse((Get-Date -UFormat %s)),

        [Parameter(
            HelpMessage = 'Number of hours the email should be considered risky (suspicious=true and blacklisted=true in the QueryResponse). Defaults to no expiration unless account_takeover tag is specified, in which case the default is 14 days'
        )]
        [int]
        $Expires = 14,

        [Parameter(
            Mandatory = $true
        )]
        [string]
        $ApiKey,

        [Parameter(
            HelpMessage = 'Submit report without confirming'
        )]
        [switch]
        $Force

        
    )

    begin {

        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
        
        $baseUrl = "https://emailrep.io/report"

        $headers = @{
            "Content-Type" = "application/json"
            'Key'          = $ApiKey
        }
    }

    process {

        foreach ($EmailAddress in $Email) {

            try {

                $body = [PSCustomObject]@{
                    email       = $EmailAddress
                    tags        = $tags
                    description = $Description
                    timestamp   = $Timestamp
                    expires     = $Expires
                } | ConvertTo-Json

                if ($force -or $PSCmdlet.ShouldProcess($body , "Reporting to EMailRep.io")) {
                    $r = Invoke-WebRequest -Method POST -Uri $baseUrl -Headers $headers -Body $body

                    $r.Content | COnvertFrom-JSON
                }
            }
            catch {
                $_.Exception
            }

        }

    }

}