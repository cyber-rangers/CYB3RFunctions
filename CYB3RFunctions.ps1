function Convert-Base64ToFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Base64String,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath
    )
    if ($PSBoundParameters.Keys -contains "FilePath") {
        [IO.File]::WriteAllBytes($FilePath, [Convert]::FromBase64String($Base64String))
    }
    else {
        $decodedBase64 = [Convert]::FromBase64String($Base64String)
        return $decodedBase64
    }
}

function Convert-FileToBase64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path $_ -PathType Leaf })]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath
    )
    $Base64String = [Convert]::ToBase64String([IO.File]::ReadAllBytes($FilePath))
    return $Base64String
}

function ConvertTo-Base64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$String
    )
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($String)
    $encoded =[Convert]::ToBase64String($bytes)
    return $encoded
}

function ConvertFrom-Base64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Base64String
    )

    $decoded = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Base64String))
    return $decoded
}