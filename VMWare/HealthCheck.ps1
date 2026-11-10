# PowerCLI Script to Run every day to spot issues across cluster, hosts, VMs, and datastores. (CSV Export)
# Use this to export an automated corporate inventory report containing vital operational details.
# @yenpuren
# https://github.com/yenpuren

Connect-VIServer vcenter.example.com

$Report = @()
$Clusters = Get-Cluster
foreach ($Cluster in $Clusters) {
    $Hosts = Get-VMHost -Location $Cluster
    $Report += [PSCustomObject]@{
        Cluster = $Cluster.Name
        HostsDown = ($Hosts | Where {$_.State -ne 'Connected'}).Count
        VMsDown = (Get-VM -Location $Hosts | Where {$_.PowerState -ne 'PoweredOn'}).Count
        DatastoresFull = (Get-Datastore -Location $Hosts | Where {$_.FreeSpaceGB/($_.CapacityGB)*100 -lt 20}).Count
        HighCPUHosts = ($Hosts | Where {$_.CpuUsageMhz -gt 80}).Count
    }
}
$Report | Export-Csv "DailyHealth-$(Get-Date -f yyyy-MM-dd).csv" -NoTypeInformation
Send-MailMessage -To admin@company.com -Subject "VMware Health Report" -Body "Check attached CSV" -Attachments "DailyHealth-$(Get-Date -f yyyy-MM-dd).csv"
