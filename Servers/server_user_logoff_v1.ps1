<#
.SYNOPSIS
    Server user logoff script.
.DESCRIPTION
    This Script gets a list of all AD servers on the network and attempts to
    log off all users that are in an idle state, while ignoring users that
    are still connected. This Script generates a log file that is located by 
    default at C:\remotelogs\
.NOTES
    File Name  : server_user_logoff_v1.ps1
    Author     : Matt Skare
#>

#creates a log directory with $LogDir as the directory root
$LogDir = "C:\remotelogs"
mkdir $LogDir

#creates the $logname variable with a time and date that can be used as the name of a file
$LogName = Get-Date -Format FileDateTime

#creates the logfile with $logname as the filename
$LogFile = "C:\remotelogs\logoff-temp-$LogName.log"

#function for writing output to the log
function Write-Log
{
   Param ([string]$LogString)

   Add-content $LogFile -value $LogString
}

#retrieves a list of AD computer names
Get-ADComputer -Filter {OperatingSystem -like "*Server*"} | Select-Object -Property Name | ForEach-Object {
    
    #name of the current machine being processed
    $CurrentMachine = $_.Name

    #record the current machine name
    Write-Log $CurrentMachine
    echo $CurrentMachine

    #query remote computer for logged on users
    quser /server:$CurrentMachine | Select-Object -Skip 1 | ForEach-Object {

        #break query into objects and store in an array
        $CurrentLine = $_.Trim() -Replace '\s+',' ' -Split '\s'
        $Props = @{
            UserName = $CurrentLine[0]
            ComputerName = $Computer
        }

        #populate array
        if ($CurrentLine[2] -eq 'Disc'){
                $Props.SessionName = $null
                $Props.Id = $CurrentLine[1]
                $Props.State = $CurrentLine[2]
                $Props.IdleTime = $CurrentLine[3]
                $Props.LogonTime = $CurrentLine[4..($CurrentLine.GetUpperBound(0))] -join ' '
        } else {
                $Props.SessionName = $CurrentLine[1]
                $Props.Id = $CurrentLine[2]
                $Props.State = $CurrentLine[3]
                $Props.IdleTime = $CurrentLine[4]
                $Props.LogonTime = $CurrentLine[5..($CurrentLine.GetUpperBound(0))] -join ' '
        }

        #decide whether or not to log off users based on activity and write to log
        if ($Props.UserName -eq "metadata2"){
            Write-Log "metadata2 is a critical process. Skipping logoff."
        } elseif ($Props.SessionName -eq $null){
            $Terminate = logoff $Props.Id /server:$CurrentMachine /v
            if($Terminate -like "Logging off session ID *"){
                $Temp = "Sucessfully logged off user " + $Props.UserName + "."
                Write-Log $Temp
            } else {
                $Temp = "An error occured attempting to log off user " + $Props.UserName
                Write-Log $Temp
            }
        } else {
            $Temp = "User " + $Props.UserName + " is still logged in. Skipping logoff."
            Write-Log $Temp
        }
    }
}