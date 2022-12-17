# PowerShellSimpleTasks Project
# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskStopOrStartService
{
    param (
        [string[]]$ServiceName,
        [string]$ActionStatus
    )

    if ($ActionStatus -eq "stop")
    {
        Stop-Service -Name $ServiceName
    } 
    elseif (($ActionStatus -eq "start")) 
    {
        Start-Service -Name $ServiceName
    }
}


