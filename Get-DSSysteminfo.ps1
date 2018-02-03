################################################################
# Author: Daniel Schwensen
# E-Mail: daniel.schwensen@gmail.com
# Created: 27.01.2018
# Last update: 03.02.2018

function Get-DSSysteminfo() {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Computer name or IP address")]
        [ValidateCount(1, 10)]
        [Alias('hostname')]
        [string[] ] $computerName,

        [string] $errorLog = 'c:\DSSysteminfo.txt',

        [switch]$LogErrors

    )

    BEGIN { Write-Verbose "Log name is $errorLog"
    }

    PROCESS {
        Write-Verbose "Beginning PROCESS block"
        foreach ($computer in $computerName) {
            Write-Verbose "Querying $computer"
            $os = gwmi -Class Win32_OperatingSystem `
                -ComputerName $computer
            $comp = gwmi -Class Win32_ComputerSystem `
                -ComputerName $computer
            $bios = gwmi -Class Win32_BIOS `
                -ComputerName $computer

            $props = [ordered]@{'ComputerName' = $computer;
                'OsVersion' = $os.version;
                'OsName' = $os.caption;
                'OsArchitecture' = $os.OSArchitecture;
                'SPVersion' = $os.servicepackmajorverison;
                'BIOS' = $bios.Description;
                'Manufacturer' = $comp.manufacturer;
                'Model' = $comp.model
            }
            Write-Verbose "WMI queries complete"
            $obj = New-Object -TypeName psobject -Property $props

            Write-Output $obj
        }

    }

    END {
    }
}
Get-DSSysteminfo -host localhost -Verbose
