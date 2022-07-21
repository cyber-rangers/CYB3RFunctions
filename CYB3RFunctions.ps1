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
    $encoded = [Convert]::ToBase64String($bytes)
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

function Convert-HexToByteArray {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Hex
    )
    
    (0..([Math]::Floor( ($hex.Length + 1) / 2) - 1)).ForEach({ [Convert]::ToByte($(if ($hex.Length -ge 2 * ($_ + 1)) { $hex.Substring($_ * 2, 2) } else { $hex.Substring($_ * 2, 1).PadRight(2, '0') }), 16) })
}

function Convert-RegDateToDate {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Enter registry date value in form 73-9D-84-EC-B5-45-D8-01')]
        [ValidateNotNullOrEmpty()]
        [string]$RegValue
    )

    $byteArray = Convert-HexToByteArray -hex ($RegValue -replace '-', '')
    $Int64Value = [System.BitConverter]::ToInt64($byteArray, 0)
    $date = [DateTime]::FromFileTime($Int64Value)
    #returns datetime in UTC!
    return $date.ToUniversalTime()
}