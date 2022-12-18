# PowerShellSimpleTasks Project
# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskReadingJson
{
    param (
        [string]$Path
    )
    
    # Using -Raw switch paremeter here both increases performance and prevents
    # possible bugs and unpredictable behaviour of ConvertFrom-Json cmdlet.
    # For more information, please visit:
    # https://github.com/PowerShell/PowerShell/issues/12229#issuecomment-873128946
    Get-Content -Path $Path -Raw | ConvertFrom-Json | Write-Output
}
