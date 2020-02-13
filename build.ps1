param(
    [string[]]$Tasks
)

function Install-Dependency([string] $Name)
{
    $policy = Get-PSRepository -Name "PSGallery" | Select-Object -ExpandProperty "InstallationPolicy"
    if($policy -ne "Trusted") {
        Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
    }

    if (!(Get-Module -Name $Name -ListAvailable)) {
        Install-Module -Name $Name -Scope CurrentUser
    }
}

function Analyze-Scripts
{
    param(
        [string]$Path = "$PSScriptRoot\PSEmailRep"
    )
    $result = Invoke-ScriptAnalyzer -Path $Path -Severity @('Error', 'Warning') -Recurse
    if ($result) {
       $result | Format-Table
       Write-Error -Message "$($result.SuggestedCorrections.Count) linting errors or warnings were found. The build cannot continue."
       EXIT 1
    }
}

function Run-Tests
{
    param(
        [string]$Path = "$PSScriptRoot\tests"
    )

    $results = Invoke-Pester -Path $Path -CodeCoverage $Path\*\*\*\*.ps1 -PassThru -Quiet
    if($results.FailedCount -gt 0) {
       Write-Output "  > $($results.FailedCount) tests failed. The build cannot continue."
       foreach($result in $($results.TestResult | Where-Object {$_.Passed -eq $false} | Select-Object -Property Describe,Context,Name,Passed,Time)){
            Write-Output "    > $result"
       }

       EXIT 1
    }
    $coverage = [math]::Round($(100 - (($results.CodeCoverage.NumberOfCommandsMissed / $results.CodeCoverage.NumberOfCommandsAnalyzed) * 100)), 2);
    Write-Output "  > Code Coverage: $coverage%"
}

function Deploy-Modules
{
    param(
        [string]$Path = "$PSScriptRoot"
    )

    try {

       foreach($module in $(Get-ChildItem -Path $Path | Where-Object {$_.Name.ToLower().Contains("psdeploy")})){
         $name = $module.Name.Split(".")[0]
         $localManifest = Import-PowerShellDataFile -Path $(Join-Path -Path $module.DirectoryName -ChildPath "$name\$name.psd1")
         if([Version]$localManifest.ModuleVersion -gt $(Find-Module -Name $name -Repository "PowerShell" -ErrorAction SilentlyContinue).Version) {
             Write-Output "> Deploying $name"
             Invoke-PSDeploy -Path $module.FullName -Force
         } else {
             Write-Output "Latest version already deployed."
         }
       }
    }
    catch {
       Write-Output $_.Exception.Message
       EXIT 1
    }
}

foreach($task in $Tasks){
    switch($task)
    {
        "analyze" {
            Install-Dependency -Name "PSScriptAnalyzer"
            Write-Output "Analyzing Scripts..."
            Analyze-Scripts
        }
        "test" {
            Install-Dependency -Name "Pester"
            Write-Output "Running Pester Tests..."
            Run-Tests
        }
        "deploy" {
            Install-Dependency -Name "PSDeploy"
            Write-Output "Deploying Modules..."
            Deploy-Modules
        }
    }
}

