function Get-DSSysteminfo() {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string[] ] $computerName,

        [string] $errorLog = "c:\DSSysteminfo.txt"

    )

    BEGIN { Write-Output "Log name is $errorLog" -Verbose
    }

    PROCESS {
        foreach ($computer in $computerName) {
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
            $obj = New-Object -TypeName psobject -Property $props

            Write-Output $obj
        }

    }

    END {
    }
}
Get-DSSysteminfo -computerName localhost
