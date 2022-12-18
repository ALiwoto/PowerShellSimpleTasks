# Copyright (C) 2022 ALiwoto
# This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of the source code.

function Invoke-TaskCallingAPI
{
    param (
        [string]$UserName,
        [string]$RepoName,
        [ValidateRange(1,100)]
        [int]$PerPage = 100
    )

    $body = @{
        per_page = $PerPage
    }

    $uri = "https://api.github.com/repos/$UserName/$RepoName/issues"
    while ($uri)
    {
        $response = Invoke-WebRequest -Uri $uri -Body $body -UseBasicParsing
        $response.Content | ConvertFrom-Json | Write-Output

        $uri = $null
        foreach ($link in $response.Headers.Link -split ",")
        {
            if ($link -match '\s*<(.*)>;\s+rel="next"')
            {
                $uri = $Matches[1]
            }
        }
    }
}