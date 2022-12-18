# PowerShellSimpleTasks Project
# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskServiceList
{
    [CmdletBinding()]
    param (
        [string[]]$Name,
        [int]$ServiceLimit
    )
    
    if ([string]::IsNullOrEmpty($Name))
    {
        # Get-Service cmdlet will throw an error if we pass null/empty string
        # to it.. so what's the choice? we can just use wild card for everything
        # (which is "*") to prevent this.
        $Name = "*"
    }

    $allServices = Get-Service -Name $Name -ErrorAction "SilentlyContinue"

    if ($ServiceLimit -ge 1)
    {
        # Select-Object returns a PSCustom instance which.. will get displayed
        # really badly when it gets printed to the console.
        # We used Format-Table here to make sure the data gets pretty-printed.
        $allServices | Select-Object -First $ServiceLimit
    }

    return $allServices | Format-Table @("Name", "Status", "StartType")
}
