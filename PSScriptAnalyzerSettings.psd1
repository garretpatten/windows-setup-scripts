@{
    Severity = @('Error', 'Warning')
    ExcludeRules = @(
        # Progress / status output is intentional for interactive provisioning.
        'PSAvoidUsingWriteHost'
        # Omarchy-style helpers use Ensure-*/Link-* naming (mirrors Ubuntu).
        'PSUseApprovedVerbs'
        # Section validators intentionally use plural nouns (Packages, Apps, …).
        'PSUseSingularNouns'
        # Leaf installers are not interactive cmdlets; -WhatIf is not useful here.
        'PSUseShouldProcessForStateChangingFunctions'
        # Prefer UTF-8 without BOM across macOS/Linux/Windows editors.
        'PSUseBOMForUnicodeEncodedFile'
        # Start-Job -ArgumentList + param() is correct; rule false-positives here.
        'PSUseUsingScopeModifierInNewRunspaces'
    )
}
