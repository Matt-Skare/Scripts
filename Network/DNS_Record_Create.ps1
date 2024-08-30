<#
.SYNOPSIS
    Create A and PTR Records for hosts in a CSV file
.DESCRIPTION
    Create A and PTR Records for hosts in a CSV file
.NOTES
    File Name  : DNS_Record_Create.ps1
    Author     : Matt Skare
#>

$dns_server = "FQDN"
$domain = "DOMAIN"

Import-CSV C:\Users\arschm.AD\desktop\Network_Devices_DNS_A_Records.csv | ForEach-Object {

#Define the Variables
$computer = "$($_.Computer).$domain"
$ip_addr = $_.IP_Address -split "\."
$rev_zone = "$($ip_addr[2]).$($ip_addr[1]).$($ip_addr[0]).in-addr.arpa" 

#Create A Records
dnscmd $dns_server /recordadd $domain "$($_.Computer)" A "$($_.IP_Address)"

#Create PTR Records
dnscmd $dns_server /recordadd $rev_zone "$($ip_addr[3])" PTR $computer

}