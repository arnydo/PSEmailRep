---
external help file: PSEmailRep-help.xml
Module Name: PSEmailRep
online version:
schema: 2.0.0
---

# New-EmailRep

## SYNOPSIS
Submit a new report to EmailRep.io

## SYNTAX

```
New-EmailRep [-Email] <String[]> -Tags <String[]> [-Description <String>] [-Timestamp <Int32>]
 [-Expires <Int32>] -ApiKey <String> [-Force] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Reports an email address.
Date of malicious activity defaults to the current time unless otherwise specified.

## EXAMPLES

### EXAMPLE 1
```
New-EmailRep -Email test_emailrep_xxxxx@foobar.com -Description "Business email compromise" -Tags bec -Force
```

status 
------ 
success

## PARAMETERS

### -Email
Email address being reported.

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

### -Tags
Tags that should be applied.

account_takeover - Legitimate email has been taken over by a malicious actor
bec - Business email compromise, whaling, contact impersonation/display name spoofing
brand_impersonation - Impersonating a well-known brand (e.g.
Paypal, Microsoft, Google, etc.)
browser_exploit - The hosted website serves an exploit
credential_phishing - Attempting to steal user credentials
generic_phishing - Generic phishing, should only be used if others don't apply or a more specific determination can't be made or would be too difficult
malware - Malicious documents and droppers.
Can be direct attachments, indirect free file hosting sites or droppers from malicious websites
scam - Catch-all for scams.
Sextortion, payment scams, lottery scams, investment scams, fake bank scams, etc.
spam - Unsolicited spam or spammy behavior (e.g.
forum submissions, unwanted bulk email)
spoofed - Forged sender email (e.g.
the envelope from is different than the header from)
task_request - Request that the recipient perform a task (e.g.
gift card purchase, update payroll, send w-2s, etc.)
threat_actor - Threat actor/owner of phishing kit

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Additional information and context.

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

### -Timestamp
When this activity occurred in UTC.
Defaults to now().

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [int][double]::Parse((Get-Date -UFormat %s))
Accept pipeline input: False
Accept wildcard characters: False
```

### -Expires
Parameter description

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 14
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApiKey
Number of hours the email should be considered risky (suspicious=true and blacklisted=true in the QueryResponse).
Defaults to no expiration unless account_takeover tag is specified, in which case the default is 14 days.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Submit report without confirmation prompt.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
https://emailrep.io/docs/#report-an-email-address

## RELATED LINKS
