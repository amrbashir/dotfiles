<#
.SYNOPSIS
    Update $Env:Path from Machine and User environment variables so it updates in the current session. 
#>
Function Update-PATH {
   $machinepath = [System.Environment]::GetEnvironmentVariable("Path", "Machine");
   $userpath = [System.Environment]::GetEnvironmentVariable("Path", "User")
   $Env:Path = $machinepath + ";" + $userpath
}

<#
.SYNOPSIS
    Add a directory to the PATH environment variable. Updates the current session PATH as well.
.PARAMETER Path
    The directory to add to PATH.
.PARAMETER Scope
    The scope of the environment variable. Can be "User" or "Machine". Default is "User".
#>
Function Add-ToPATH {
    param(
        [string]$Path,
        [string]$Scope = "User"
    )

    $oldpath = [System.Environment]::GetEnvironmentVariable("Path", $Scope)
    $newpath = $oldpath + ";" + $Path
    [System.Environment]::SetEnvironmentVariable("Path", $newpath, $Scope)
    Update-PATH
}

<#
.SYNOPSIS
    Remove duplicates from the PATH environment variable.
.PARAMETER Scope
    The scope of the environment variable. Can be "User" or "Machine". Default is "User".
#>
Function Remove-PATHDuplicates {
    param(
        [string]$Scope = "User"
    )
    $oldpath = [System.Environment]::GetEnvironmentVariable("Path", $Scope)
    $newpath = ($oldpath -split ';' | Select-Object -Unique) -join ';'
    [System.Environment]::SetEnvironmentVariable("Path", $newpath, $Scope)
    Update-PATH
}

<#
.SYNOPSIS
    Add or update an environment variable. Updates the current session as well.
.PARAMETER Name
    The name of the environment variable.
.PARAMETER Value
    The value of the environment variable.
.PARAMETER Scope
    The scope of the environment variable. Can be "User", "Machine", or "Process". Default is "User".
#>
Function Add-EnvVar {
    param(
        [string]$Name,
        [string]$Value,
        [string]$Scope = "User"
    )
    [System.Environment]::SetEnvironmentVariable($Name, $Value, $Scope)
    Set-Item -Path "Env:$Name" -Value $Value
}

<#
.SYNOPSIS
    Add an application to Windows startup by creating a registry entry in "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run".
.PARAMETER Name
    The name of the startup application entry.
.PARAMETER Path
    The path to the application executable.
.PARAMETER AppArgs
    Optional arguments to pass to the application.
#>
Function Add-StartupApp {
    param(
        [string]$Name,
        [string]$Path,
        [string]$StartupArgs = ""
    )
    $StartupArgs = if ($StartupArgs -eq "") { "" } else { " $StartupArgs" }
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $Name -Value "`"$Path`"$StartupArgs"
}

<#
.SYNOPSIS
    Remove an application from Windows startup by deleting its registry entry in "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run".
.PARAMETER Name
    The name of the startup application entry to remove.
#>
Function Remove-StartupApp {
    param(
        [string]$Name
    )
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $Name
}

<#
.SYNOPSIS
    Create a symbolic link for a configuration file in a target directory. Creates the target directory if it does not exist and removes any existing file at the target location.
.PARAMETER Path
    The source configuration file to link.
.PARAMETER ToDir
    The target directory where the symbolic link will be created.
.PARAMETER ToFile
    The name of the symbolic link file in the target directory.
#>
function New-ConfigSymlink {
    param(
        [string]$Path,
        [string]$ToDir,
        [string]$ToFile
    )
    New-Item -Path $ToDir -ItemType Directory -Force
    $to = Join-Path -Path $ToDir -ChildPath $ToFile

    if (Test-Path -Path $to) {
        Remove-Item -Path $to -Force
    }

    New-Item -ItemType SymbolicLink -Target $Path -Path $to
}

<#
.SYNOPSIS
    Set an alias to a command with optional arguments by creating an intermediate function then aliasing to it.
.PARAMETER AliasName
    The name of the alias to create.
.PARAMETER Command
    The command to alias, can include arguments.
.PARAMETER WrapperFn
    Optional name for the intermediate function. If not provided, defaults to "__<AliasName>".
#>
Function Set-AliasEx {
    param (
        [string]$AliasName,
        [string]$Command,
        [string]$WrapperFn = ""
    )

    $WrapperFn = if ($WrapperFn -eq "") { "__$AliasName" } else { "$WrapperFn" }

    Remove-Alias $AliasName -Force -ErrorAction SilentlyContinue

    $functionScript = "Function global:$WrapperFn {$Command `$args }"
    Invoke-Expression $functionScript

    Set-Alias $AliasName "$WrapperFn" -Scope Global -Force
}

<#
.SYNOPSIS
    Remove an alias or built-in function.
.PARAMETER AliasName
    The name of the alias to remove.
#>
Function Remove-AliasEx {
    param (
        [string]$AliasName
    )

    # Remove at script level
    if (Get-Alias $AliasName -ErrorAction SilentlyContinue) { Remove-Alias $AliasName -Force }
    # Remove at global level
    if (Get-Alias $AliasName -ErrorAction SilentlyContinue) { Remove-Alias $AliasName -Force }

    $maybeFunction = Get-Command $AliasName -ErrorAction SilentlyContinue
    if ($maybeFunction -and $maybeFunction.CommandType -eq 'Function') {
        Remove-Item "Function:$AliasName" -Force
    }
}

<#
.SYNOPSIS
    Set an alias for a git command, ensuring the alias is setup correctly for posh-git integration.
.PARAMETER AliasName
    The name of the alias to create.
.PARAMETER GitCommand
    The git command to alias, can include arguments.
#>
Function Set-GitAlias {
    param (
        [string]$AliasName,
        [string]$GitCommand
    )

    $gitVerb = $GitCommand.Split(' ')[1]
    Set-AliasEx $AliasName $GitCommand -WrapperFn "Git-$gitVerb"
}

<#
.SYNOPSIS
    Merge the nearest .gitconfig file from the current directory upwards into the current session's git configuration.
#>
Function Merge-NearestGitConfig {
    # Reset any previous temporary git config
    if ($Env:GIT_CONFIG_GLOBAL) {
        Remove-Item $Env:GIT_CONFIG_GLOBAL -ErrorAction SilentlyContinue
        Remove-Item Env:GIT_CONFIG_GLOBAL
    }

    $currentDir = Get-Location
    $nearestGitconfig = $null

    # Find the nearest .gitconfig file upwards in the directory tree
    while ($currentDir) {
        $gitconfigPath = Join-Path -Path $currentDir -ChildPath ".gitconfig"
        if (Test-Path $gitconfigPath) {
            $nearestGitconfig = $gitconfigPath
            break
        }

        # Move up one directory
        $currentDir = Split-Path -Path $currentDir -Parent
    }

    # if the found .gitconfig is not the user's global config, merge it
    if ($nearestGitconfig -and ($nearestGitconfig -ne "$HOME\.gitconfig")) {
        # Create a temporary config file with the user's global config ~/.gitconfig
        $tempConfig = [System.IO.Path]::GetTempFileName()
        Get-Content "$HOME\.gitconfig" | Set-Content $tempConfig

        # Append an include directive for the nearest .gitconfig
        $nearestGitconfig = $nearestGitconfig -replace '\\', '/' # Normalize path for git
        Add-Content $tempConfig "`n[include]`n    path = $nearestGitconfig"

        # Point Git to this merged config for the session
        $Env:GIT_CONFIG_GLOBAL = $tempConfig
        Write-Host "Merged git config from " -NoNewline 
        Write-Host $nearestGitconfig -NoNewline -ForegroundColor Cyan
        Write-Host " into current session."
    }
}


<#
.SYNOPSIS
    Create a cd alias that calls all integrations. Intended for fnm and zoxide to work together.
.PARAMETER IntegrationFunctions
    The list of integration function names to call on cd, order is important.
#>
Function Use-CDIntegrations {
    param (
        [string[]]$IntegrationFunctions
    )

    $quotedFunctions = $IntegrationFunctions | ForEach-Object { "'$_'" }
    $functionList = $quotedFunctions -join ', '
    
    $functionScript = @"
        Function global:Set-LocationWithAllIntegrations {
            foreach (`$fn in @($functionList)) {
                & `$fn @args
            }
        }
"@
    Invoke-Expression $functionScript

    Set-Alias -Name cd -Value Set-LocationWithAllIntegrations -Option AllScope -Scope Global -Force
}

