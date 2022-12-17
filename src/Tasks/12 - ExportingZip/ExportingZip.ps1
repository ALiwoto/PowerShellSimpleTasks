# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskExportingZip {
    param (
        [string[]]$Path,
        [string]$DestinationPath
    )
    
    Compress-Archive -Path $Path -DestinationPath $DestinationPath -Force
}
