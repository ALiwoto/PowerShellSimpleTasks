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
foreach ($currentDir in Get-ChildItem -Path ".\src\Tasks\" -Directory)
{
    foreach ($currentFile in Get-ChildItem -Path $currentDir.PSPath -File)
    {
        if (($currentFile.PSPath -notlike "*.ps1") -or ($currentFile.PSPath -like "*.Test.ps1"))
        {
            # prevent from dot-sourcing test files
            continue
        }
        
        # NOTE: In PowerShell 7+ it's possible to dot-source only $currentFile variable
        # (without explicity mentioning .PSPath property at all), but we will be getting
        # error in PowerShell 5.1, so we better use .PSPath so the script be compatible with
        # 5.1 version.
        "Importing script file $($currentFile.PSPath) using dot-source" | Write-Debug
        . $currentFile.PSPath
    }

    Write-Debug $currentDir
}

# Reads and returns the options provided by the user (from console)
# as an array of strings separated by comma and/or whitespace.
function Read-UserOptions
{
    return ((Read-Host) -split "[, ]" | Where-Object {$_.Trim().Length -ne 0 } )
}

# Returns true if and only if at least one of the provided InputStrings
# parameter is null.
function Get-IsNullOrEmpty
{
    param (
        [string[]]$InputStrings
    )
    
    return (($null -eq $InputStrings) -or ($InputStrings.Length -eq 0))
}

"Welcome to the PowerShellSimpleTasks script!`n" +
"This script is designed to do some simple tasks"+
" (shown in the below list) " | Write-Output

function Show-MainMenu
{
    while ($true)
    {
        "`nPlease select which task you would like to run?" | Write-Host
        "1- ServiceList`n"          +
        "2- DirsAndSubDirs`n"       +
        "3- FilesCopying`n"         +
        "4- DirsCopying`n"          +
        "5- StopOrStartServices`n"  +
        "6- MakingFunctions`n"      +
        "7- ReadingJson`n"          +
        "8- MakingJson`n"           +
        "9- CheckingServices`n"     +
        "10- PutScriptInPath`n"     +
        "11- CallingAPI`n"          +
        "12- ExportingZip`n"        +
        "13- ExpandingZip`n"        | Write-Host
    
        $userInput = Read-Host
        switch ($userInput) 
        {
            "1"
            {
                "This task will output a list of services, matching with the " +
                "word(s) you have provided (provide an empty string to list all " +
                "or separate them using comma `",`"):" | Write-Host
                $serviceName = Read-UserOptions
                
                "Would you also like to apply a limit to list of services?" | Write-Host
                $serviceLimit = Read-Host
    
                Invoke-TaskServiceList -Name $serviceName -ServiceLimit $serviceLimit
            }

            "2"
            {
                "This task will create some sub-directories under the specified " +
                "directories.`n" +
                "Give me the name of parents directories " +
                "(separated by comma): " | Write-Host
                $allParents = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $allParents)
                {
                    # make sure parent directories are not null or empty.
                    break
                }

                "Give me the name of children directories " +
                "(separated by comma): " | Write-Host
                $allChildren = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $allChildren)
                {
                    # make sure children sub-directories are not null or empty.
                    break
                }

                Invoke-TaskDirsAndSubDirs -ParentDirName $allParents -ChildrenDirName $allChildren
            }

            "3"
            {
                "This task will copy files from the specified path(s) to all of the " +
                "specified destinations.`n" +
                "Please give me path of the files/directories you want to get "+
                "copied (separated by comma): " | Write-Host
                $allSourceFiles = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $allSourceFiles)
                {
                    # make sure the source files to copy's paths isn't null or empty.
                    break
                }

                "Give me the destination path(s) (separated by comma):" | Write-Host
                $allDestinations = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $allDestinations)
                {
                    # make sure the destination paths value isn't null or empty.
                    break
                }

                Invoke-TaskFilesCopying -SourceFilesName $allSourceFiles -Destination $allDestinations
            }

            "4"
            {
                "This task will copy directories from the specified path(s) to all of the " +
                "specified destinations.`n" +
                "Please give me path of the directories you want to get "+
                "copied (separated by comma): " | Write-Host
                $allSourceDirs = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $allSourceDirs)
                {
                    # make sure the source dirs to copy's paths isn't null or empty.
                    break
                }

                "Give me the destination path(s) (separated by comma): " | Write-Host
                $allDestinations = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $allDestinations)
                {
                    # make sure the destination paths value isn't null or empty.
                    break
                }

                Invoke-TaskDirsCopying -SourceFilesName $allSourceFiles -Destination $allDestinations
            }

            "5"
            {
                "This task will stop or start the specified services.`n" +
                "Give me the desired service name(s) (separated by comma): " | Write-Host
                $servicesName = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $servicesName)
                {
                    # make sure the source dirs to copy's paths isn't null or empty.
                    break
                }

                $serviceAction = ""
                while ((($serviceAction -ne "start") -or ($serviceAction -ne "stop")))
                {
                    "Give me the action to do with the specified service(s) " +
                    "(stop/start only):" | Write-Host
                    $serviceAction = Read-Host
                }

                Invoke-TaskStopOrStartService -ServiceName $servicesName -ActionStatus $serviceAction
            }

            "6" 
            {
                Invoke-TaskMakingFunctions
            }

            "7"
            {
                "This task will read content of a json file and display its fields.`n" +
                "Give me the path to the json file to read: " | Write-Host

                Invoke-TaskReadingJson -Path (Read-Host)
            }
            
            "8"
            {
                "This task will save content of an object (a hashtable) to a json file.`n" +
                "Give me the path to the specified json file(s) "+
                "(Separated by comma): " | Write-Host
                $allJsonPaths = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $allJsonPaths)
                {
                    # make sure the destination paths value isn't null or empty.
                    break
                }

                Invoke-TaskMakingJson -Path $allJsonPaths
            }

            "9"
            {
                "This task will check if all of the services with the specified name " +
                "are in the specified state or not. `n" +
                "Give me the name of the service(s) (separated by comma): " | Write-Host
                $allServices = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $allServices)
                {
                    # make sure the the services name value isn't null or empty.
                    break
                }

                "Now give me the desired state in which these services should be in: "`
                | Write-Host
                $desiredState = Read-Host

                if (Invoke-TaskCheckingService -ServiceName $allServices -DesiredState $desiredState)
                {
                    "Yup! The services are all in the desired state!" | Write-Host
                }
                else
                {
                    $userResponse = Read-Host -Prompt ("Sadly not all services are in the desired state...`n" +
                    "Would you like to receive a list of these services alongside of their status? (Y/N)")
                    if ($userResponse -ne "y")
                    {
                        break
                    }

                    Invoke-TaskServiceList -Name $serviceName
                }
            }

            "10"
            {
                "This task will put a script path to the PATH environment variable.`n" +
                "Give me the specified path value: " | Write-Output

                $thePath = Read-Host
                $shouldBeGlobal = ((Read-Host -Prompt "Should it become global? Y/N") -eq "y")

                Invoke-TaskPutScriptInPath -Path $thePath -InGlobalEnv $shouldBeGlobal
            }

            "11"
            {
                "This task will call GitHub API and fetch issues of a repository from it.`n" +
                "Give me the username/org name of the repo: " | Write-Host
                $theUsername = Read-Host

                
                $repoName = Read-Host -Prompt "Now give me the repository name"

                $perPageLimit = [int](Read-Host -Prompt "Now give the per_page limit")

                Invoke-TaskCallingAPI -UserName $theUsername -RepoName $repoName -PerPage $perPageLimit
            }

            "12"
            {
                "This task will compress the given directories/files and compress them to a single " +
                ".zip file.`n" +
                "Give me the files/directories path that need to be compressed:" | Write-Host
                $thePath = Read-UserOptions
                if (Get-IsNullOrEmpty -InputStrings $thePath)
                {
                    # make sure the paths value aren't null or empty.
                    break
                }

                Invoke-TaskExportingZip -Path $thePath -DestinationPath (`
                    Read-Host -Prompt "Give me the destination path")
            }

            "13"
            {
                "This task will expand the given zip file and extract the content to "+
                "the specified path. `n" +
                "Give me the path to the zip file:" | Write-Host
                $thePath = Read-Host

                Invoke-TaskExpandingZip -Path $thePath -DestinationPath (`
                    Read-Host -Prompt "Give me the destination path")
            }
            Default {
                "Thanks for taking time and testing out this script!" | Write-Host
                return
            }
        }
    }
}

Show-MainMenu
