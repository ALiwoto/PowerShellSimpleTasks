# PowerShellSimpleTasks Project
# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

# This is the entry point for PowerShellSimpleTasks projects.
# If you want to bring up a user interface (UI) for the whole tasks,
# then you are in the correct place.
# To see the source code of each task (the scripts' source code), you have
# to open up each directory specified for that task.

# the following loop will go over all of our tasks directory 
# (with the format of "num - TaskName")
# and dot-source all of the scripts in each task directory 
# please do notice that (files with "*.Test.ps1" format are not dot-sourced).
foreach ($currentDir in Get-ChildItem -Path ".\src\Tasks\" -Directory) {
    foreach ($currentFile in Get-ChildItem -Path $currentDir.PSPath -File) {
        if (($currentFile.PSPath -notlike "*.ps1") -or ($currentFile.PSPath -like "*.Test.ps1")) {
            # prevent from dot-sourcing test files
            continue
        }
        
        "Importing script file $currentFile using dot-source" | Write-Debug
        . $currentFile
    }

    Write-Debug $currentDir
}

# Reads and returns the options provided by the user (from console)
# as an array of strings separated by comma and/or whitespace.
function Read-UserOptions {
    return ((Read-Host) -split "[, ]" | Where-Object {$_.Trim().Length -ne 0 } )
}

"Welcome to the PowerShellSimpleTask script!`n" +
"This script is designed to do some simple tasks"+
" (shown in the below list) " | Write-Output

function Show-MainMenu {
    while ($true) {
        "`nPlease select which task you would like to run?" | Write-Host
        "1- ServiceList`n" +
        "2- DirsAndSubDirs`n" | Write-Host
    
        $userInput = Read-Host
        switch ($userInput) {
            "1" {
                "This task will output a list of services, matching with the " +
                "word(s) you have provided (provide an empty string to list all " +
                "or separate them using comma `",`":" | Write-Host
                $serviceName = Read-UserOptions
                
                "Would you also like to apply a limit to list of services?" | Write-Host
                $serviceLimit = Read-Host
    
                Invoke-TaskServiceList -Name $serviceName -ServiceLimit $serviceLimit
            }
            "2" {
                "This task will create some sub-directories under the specified " +
                "directories.`n" +
                "Give me the name of parents directories " +
                "(separated by comma): " | Write-Host
                $allParents = Read-UserOptions
                if (($null -eq $allParents) -or ($allParents.Length -eq 0)) {
                    # make sure parent directories are not null or empty.
                    break
                }

                "Give me the name of children directories " +
                "(separated by comma): " | Write-Host
                $allChildren = Read-UserOptions
                if (($null -eq $allChildren) -or ($allChildren.Length -eq 0)) {
                    # make sure children sub-directories are not null or empty.
                    break
                }

                Invoke-TaskDirsAndSubDirs -ParentDirName $allParents -ChildrenDirName $allChildren
            }
            "3" {
                
            }
            Default {
                "Thanks for taking time and testing out this script!" | Write-Host
                return
            }
        }
    }
}

Show-MainMenu
