# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskPutScriptInPath {
    param (
        [string]$Path,
        [switch]$InGlobalEnv
    )
    
    if ($InGlobalEnv.ToBool())
    {
        $Path = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $Path
        [System.Environment]::SetEnvironmentVariable( "Path", $Path, "Machine" )
    }
    else
    {
        $Env:Path += [IO.Path]::PathSeparator + $Path
    }
}


