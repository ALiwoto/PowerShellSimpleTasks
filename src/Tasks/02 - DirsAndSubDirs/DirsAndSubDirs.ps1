# PowerShellSimpleTasks Project
# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskDirsAndSubDirs
{
    param (
        [string[]]$ParentDirName,
        [string[]]$ChildrenDirName
    )

    foreach ($currentParent in $ChildrenDirName)
    {
        New-Item -Path $ParentDirName -Name $currentParent -ItemType "Directory"
    }
}