# PowerShellSimpleTasks Project
# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskFilesCopying
{
    param (
        [string[]]$SourceFilesName,
        [string[]]$Destination
    )
    
    foreach ($currentDestination in $Destination)
    {
        Copy-Item -Path $SourceFilesName -Destination $currentDestination -Force
    }
}