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


"Welcome to the PowerShellSimpleTask script!`n" +
"This script is designed to do some simple tasks"+
" (shown in the below list) " | Write-Output

function Show-MainMenu {
    while ($true) {
        "Please select which task you would like to run?" | Write-Host
        "1- ServiceList`n" +
        "2- DirsAndSubDirs`n" | Write-Host
    
        $userInput = Read-Host
        switch ($userInput) {
            "1" {
                "This task will output a list of services, matched with the " +
                "word(s) you are providing (provide an empty string to list all " +
                "or separate them using comma `",`":" | Write-Host
                $serviceName = (Read-Host) -split ","
                
                "Would you also like to apply a limit to list of services?" | Write-Host
                $serviceLimit = Read-Host
    
                Invoke-TaskServiceList -Name $serviceName -ServiceLimit $serviceLimit
            }
            "2" {
                "Here" | Write-Host
            }
            Default {
                "Thanks for taking time and testing out this script!" | Write-Host
                return
            }
        }
    }
}

Show-MainMenu
