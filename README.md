[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/PSEmailRep.svg)](https://www.powershellgallery.com/packages/PSEmailRep)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/PSEmailRep.svg)](https://www.powershellgallery.com/packages/PSEmailRep)

# PSEmailRep

PSEmailRep is a simple PowerShell module to interface with the EmailRep.io API.

![ScreenShot](/Media/screenshot.png)

## What is EmailRep.io?

[EmailRep.io](https://emailrep.io/) EmailRep is a system of crawlers, scanners and enrichment services that collects data on email addresses, domains, and internet personas.

EmailRep uses hundreds of data points from social media profiles, professional networking sites, dark web credential leaks, data breaches, phishing kits, phishing emails, spam lists, open mail relays, domain age and reputation, deliverability, and more to predict the risk of an email address.

# PSEmailRep Commands

## Get-EmailRep

```powershell
> Get-EmailRep -EmailAddress bill@microsoft.com

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
profiles                   : {flickr, myspace, spotify, pinterest...}
```

## New-EmailRep
```powershell
> New-EmailRep -Email test_emailrep_xxxxx@foobar.com -Tags bec -Description 'Business email takeover' -ApiKey $ApiKey

Status
------
Success
```

## Set-EmailRep
```powershell
> Set-EmailRep -APIKey

APIKey: ********************************
```

## Additional Documentation
[Additional Documentation](/Docs)

# Installing PSEmail

## PSGallery
```powershell
Install-Module -Name PSEmailRep -Repository PSGallery

Import-Module -Name PSEmailRep
```

## Clone the repo
```powershell
git clone https://github.com/arnydo/psemailrep.git

cd psemailrep/psemailrep

Import-Module PSEmailRep.psd1
```
