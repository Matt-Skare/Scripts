<#
.SYNOPSIS
	Server restart script.
.DESCRIPTION
	This Script restarts server on the domain based off of whether
    or not there are users logged in. This Script generates a log 
    file that is located by default at C:\remotelogs\
.NOTES
	File Name  : server_restart_v1.ps1
	Author     : Matt Skare
#>

#creates a log directory with $LogDir as the directory root
$LogDir = "C:\remotelogs\"
mkdir $LogDir

#creates the $logname variable with a time and date that can be used as the name of a file
$LogName = Get-Date -Format FileDateTime

#creates the logfile with $logname as the filename
$LogFile = "C:\remotelogs\shutdown-$LogName.log"

#function for writing output to the log
function Write-Log
{
	Param ([string]$LogString)

	Add-content $LogFile -value $LogString
}

#retrieves a list of AD computer names
Get-ADComputer -Filter {OperatingSystem -like "*Server*"} | Select-Object -Property Name | ForEach-Object {
    
	#active user counter
	$ActiveUserCount = 0
	$MetaView = $FALSE

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

		#determine if there are active or idle users logged in to a server
		if ($Props.UserName -eq "metadata2"){
            $Temp = "  Skipping restart of $CurrentMachine because metadata2 is a critical process."
            $MetaView = $TRUE
			echo $Temp
			Write-Log $Temp
		} elseif ($Props.SessionName -eq $null){
			$Temp = "  User " + $Props.UserName + " is idle."
			echo $Temp
			Write-Log $Temp
		} else {
            $ActiveUserCount++

			$Temp = "  User " + $Props.UserName + " is logged in."
            echo $Temp
			Write-Log $Temp
		}
	}
    
    #decide whether or not to restart servers based on activity and write to log
    if ($MetaView -eq $TRUE) {
        $Temp = "    Did not restart $CurrentMachine because metadata2 is a critical process."
        echo $Temp
        Write-Log $Temp
    } elseif ($ActiveUserCount -gt 0){
        $Temp = "    Did not restart $CurrentMachine because there are users still logged in."
        echo $Temp
        Write-Log $Temp
    } else {
        $Temp = "    Restarting $CurrentMachine...."
        echo $Temp
        Write-Log $Temp
        
        (gwmi win32_operatingsystem -ComputerName $CurrentMachine).Win32Shutdown(6)
        Start-Sleep -s 2

        $ConnectionTest = Test-Connection $CurrentMachine -Quiet
        if ($ConnectionTest -eq $FALSE) {
            $Temp = "      Successfully shut down $CurrentMachine."
            echo $Temp
            Write-Log $Temp
        } else {
            $Temp = "      Failed to shut down $CurrentMachine."
            echo $Temp
            Write-Log $Temp
        }
    }
}