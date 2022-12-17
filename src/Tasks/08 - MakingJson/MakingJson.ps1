# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskMakingJson
{
    param (
        [string[]]$Path
    )
    
    $myObject = @{
        "field1" = "value1";
        "field2" = @{
            "field3" = @(
                "value2",
                "value3",
                "value4"
            )
        }
    }

    New-Item -Path $Path -ItemType "File" -Value ($myObject | ConvertTo-Json)`
    -Force | Write-Output
}
