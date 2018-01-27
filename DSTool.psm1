################################################################
# Author: Daniel Schwensen
# E-Mail: daniel.schwensen@nielsen.com
#
#
#
# Chapter 7.1

function Get-DSSysteminfo() {
    <#
.SYNOPSIS
Retrieves key system version and model information
from one to ten computers.
.DESCRIPTION
Get-SystemInfo uses Windows Management Instrumentation
(WMI) to retrieve information from one or more computers.
Specify computers by name or by IP address.
.PARAMETER ComputerName
One or more computer names or IP addresses, up to a maximum
of 10.
.PARAMETER LogErrors
Specify this switch to create a text log file of computers
that could not be queried.
.PARAMETER ErrorLog
When used with -LogErrors, specifies the file path and name
to which failed computer names will be written. Defaults to
C:\Retry.txt.
.EXAMPLE
 Get-Content names.txt | Get-DSSystemInfo
.EXAMPLE
 Get-DSSystemInfo -ComputerName SERVER1,SERVER2
#>
    [CmdletBinding()] 
    param(
        [Parameter(Mandatory = $true)]
        [string[] ] $computerName,

        [string] $errorLog = "c:\test.txt"
        
    )
    
    BEGIN { Write-Output "Log name is $errorLog"}

    PROCESS {
        foreach ($computer in $computerName) {
            $os = gwmi -Class Win32_OperatingSystem `
                -ComputerName $computer
            $comp = gwmi -Class Win32_ComputerSystem `
                -ComputerName $computer
            $bios = gwmi -Class Win32_BIOS `
                -ComputerName $computer

            $props = @{'ComputerName' = $computer;
                'OsVersion'           = $os.version;
                'SPVersion'           = $os.servicepackmajorverison;
                'BIOSSerial'          = $bios.serialnumber;
                'Manufacturer'        = $comp.manufacturer;
                'Model'               = $comp.model 
            }
            $obj = New-Object -TypeName psobject -Property $props

            Write-Output $obj
        }
       
    }

    END {}
}
#Get-Systeminfo -computerName localhost, localhost -errorLog 
    