---
external help file: PSEmailRep-help.xml
Module Name: PSEmailRep
online version:
schema: 2.0.0
---

# Get-EmailRep

## SYNOPSIS
Query the EmailRep.io API for a report on an email address.

## SYNTAX

```
Get-EmailRep [-EmailAddress] <String[]> [-Summary] [-ApiKey <String>] [-UserAgent <String>] [-Raw] [-APIStatus]
 [<CommonParameters>]
```

## DESCRIPTION
EmailRep uses hundreds of data points from social media profiles, professional networking sites,
dark web credential leaks, data breaches, phishing kits, phishing emails, spam lists,
open mail relays, domain age and reputation, deliverability,
and more to predict the risk of an email address.
https://emailrep.io/docs/#emailrep-alpha-api

## EXAMPLES

### EXAMPLE 1
```
Get-EmailRep -EmailAdress bill@microsoft.com
```

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

### EXAMPLE 2
```
Get-EmailRep -EmailAdress bill@microsoft.com -Raw
```

email      : bill@microsoft.com
reputation : high
suspicious : False
references : 79
details    : @{blacklisted=False; malicious_activity=False; malicious_activity_recent=False; credentials_leaked=True; credentials_leaked_recent=False; 
            data_breach=True; first_seen=07/01/2008; last_seen=05/24/2019; domain_exists=True; domain_reputation=high; new_domain=False;
            days_since_domain_creation=10354; suspicious_tld=False; spam=False; free_provider=False; disposable=False; deliverable=True; accept_all=True;     
            valid_mx=True; spoofable=False; spf_strict=True; dmarc_enforced=True; profiles=System.Object\[\]}

### EXAMPLE 3
```
Get-EmailRep -EmailAdress bill@microsoft.com -APIStatus
```

Daily queries remaining: 92
...

### EXAMPLE 4
```
"bill@microsoft.com" | Get-EmailRep
```

### EXAMPLE 5
```
"bill@microsoft.com","john@microsoft.com" | Get-EmailRep | ft email,reputation,credentials_leaked
```

email              reputation credentials_leaked
-----              ---------- ------------------
bill@microsoft.com high                     True
john@microsoft.com high                     True

## PARAMETERS

### -EmailAddress
Email address to be queried.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Summary
When set to $true, a summary about the email address will be returned.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
API key to authenticate against api.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserAgent
Specify the user agent of the web request.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: PSEmailRep Powershell Module
Accept pipeline input: False
Accept wildcard characters: False
```

### -Raw
The original API response will be displayed.
By default, the 'details' object is not a nested object.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -APIStatus
Return current query quota status.
Daily or Monthly based on type of API key being used.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
https://emailrep.io/docs/#emailrep-alpha-api

## RELATED LINKS
