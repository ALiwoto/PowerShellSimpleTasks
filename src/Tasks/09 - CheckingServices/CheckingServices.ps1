# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskCheckingService
{
    param (
        [string[]]$ServiceName,
        [string]$DesiredState 
    )
    
    $myServices = Get-Service -Name $ServiceName

    foreach ($currentService in $myServices)
    {
        if ($currentService.Status -ne $DesiredState)
        {
            return $false
        }
    }

    return $true
}
