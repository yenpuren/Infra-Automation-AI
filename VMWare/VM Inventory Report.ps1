# PowerCLI Script to Generate Complete VM Inventory Report (CSV Export)
# Use this to export an automated corporate inventory report containing vital operational details.
# @yenpuren
# https://github.com/yenpuren

Connect-VIServer -Server "vcenter.yourdomain.local"

$ExportPath = "C:\Reports\VM_Inventory_Report_$(Get-Date -Format 'yyyyMMdd').csv"

Write-Host "Gathering VM details and exporting to $ExportPath..." -ForegroundColor Cyan

Get-VM | Select-Object `
    Name, 
    PowerState, 
    NumCpu, 
    MemoryGB, 
    ProvisionedSpaceGB, 
    UsedSpaceGB,
    @{N="IPAddress";E={$_.Guest.IPAddress[0]}},
    @{N="OS";E={$_.Guest.OSDescription}},
    @{N="ESXiHost";E={$_.VMHost.Name}},
    @{N="ToolsStatus";E={$_.ExtensionData.Guest.ToolsStatus}} | 
    Export-Csv -Path $ExportPath -NoTypeInformation

Write-Host "Export completed successfully!" -ForegroundColor Green
Disconnect-VIServer -Confirm:$false
