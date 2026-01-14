<#
.SYNOPSIS
    Update $env:Path from Machine and User environment variables so it updates in the current session. 
#>
Function Update-PATH {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

<#
.SYNOPSIS
    Add a directory to the User PATH environment variable. Updates the current session PATH as well.
.PARAMETER Path
    The directory to add to PATH.
#>
Function Add-ToPATH {
    param(
        [string]$Path
    )

    $newpath = $Path + ";" + [System.Environment]::GetEnvironmentVariable("Path")
    [System.Environment]::SetEnvironmentVariable("Path", $newpath, "User")
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
.PARAMETER File
    The source configuration file to link.
.PARAMETER ToDir
    The target directory where the symbolic link will be created.
.PARAMETER ToFile
    The name of the symbolic link file in the target directory.
#>
function Set-ConfigSymlink {
    param(
        [string]$File,
        [string]$ToDir,
        [string]$ToFile
    )
    New-Item -Path $ToDir -ItemType Directory -Force
    $to = $ToDir + $ToFile

    if (Test-Path -Path $to) {
        Remove-Item -Path $to -Force
    }

    New-Item -ItemType SymbolicLink -Target $File -Path $to
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

<#.SYNOPSIS
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