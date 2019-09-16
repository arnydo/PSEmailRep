function Set-EmailRep {
    <#
    .SYNOPSIS
    Set API Key for persistent use.
    
    .DESCRIPTION
    Set API Key for persistent use in encrypted string.
    Default file location is in user's AppData folder.
    
    .PARAMETER APIKey
    Set new API Key.
    
    .PARAMETER Test
    Test retrieval of API Key.
    
    .EXAMPLE
    Set-EmailRep -API

    API Key: ***************************************
    
    #>
    

    [cmdletbinding()]
    
    param(
        [switch]$APIKey,

        [switch]$Test
    )

    if ($APIKey) {
        try {
            if (-not (Test-Path $env:appdata\PSEmailRep)) {
                New-Item -Path $env:appdata -Name PSEmailRep -ItemType Directory
            }
            else {
                Write-Warning "API Key already configured. Overwrite existing?"
                $response = Read-Host -Prompt "Y/N"

                switch ($response) {
                    "Y" { Write-Host "Overwriting existing key..." -ForegroundColor Yellow }
                    "N" {
                        Write-Host "Keeping exising. Exiting..." -ForegroundColor Yellow
                        return
                    }
                    default {
                        Write-Host "Response unknown. Try again..."
                        return
                    }
                } 

            }
    
            $Key = Read-Host -Prompt "API Key" -AsSecureString



            $Key | ConvertFrom-SecureString | Out-File $env:appdata\PSEmailRep\api.txt
        }
        catch {

        }

    }

    if ($test) {
        $testkey = Get-Content $env:appdata\PSEmailRep\api.txt | ConvertTo-SecureString
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "API Key", $testkey
        $Credential.GetNetworkCredential().password
    }

    
}