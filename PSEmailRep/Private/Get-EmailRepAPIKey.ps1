function Get-EmailRepAPIKey {
    <#
    .SYNOPSIS
    Private function to retrieve encrypted API Key.
    
    .DESCRIPTION
    Private function to retrieve encrypted API Key in user's AppData.
    
    .EXAMPLE
    Get-EmailRepAPIKey

    2d9287n9d872b9873p8j2873bd67235v6b8d923fsfn2837d
    
    .NOTES
    General notes
    #>
    
    try {
        $testkey = Get-Content $env:appdata\PSEmailRep\api.txt | ConvertTo-SecureString
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "API Key", $testkey
        return [string]$Credential.GetNetworkCredential().password   
    }
    catch {
        
    }
    end {
        Write-Verbose "Complete"
    }
}

