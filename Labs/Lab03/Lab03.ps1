#Parameters
param(
    [Parameter(Mandatory)]
    [int]$MemoryLimitMB
)

#Show an error if the value is lower than 0
if ($MemoryLimitMB -le 0) {
    Throw "MemoryLimitMB must be greater than 0"
}



#Get the processes and save into a file
$processes = Get-process |
#Filter based on parametrized memory value for workingset in MB
                 Where-Object {$_.WorkingSet -gt $MemoryLimitMB*1MB} |
#Sort the results from highest to lowest
                     Sort-Object -Property WorkingSet -Descending |
#Show only the name, id, CPU, calculated property WorkingSetMB and CheckedAt
                         Select-Object -Property Name, Id, CPU,
                             @{
                                Name = "WorkingSetMB"
                                Expression = {
                                    [math]::Round(($_.WorkingSet/1MB), 2)
                                }
                             },
                             @{
                                Name = "CheckedAt"
                                Expression = {Get-Date -Format "dd-MM-yyyy HH:mm"}
                             }
Write-Host "Found $($processes.Count) matching processes"
#Export into csv
$processes | Export-csv "C:\Users\averna\OneDrive - Capgemini\Desktop\Psh AZ 104 scripts\Psh exercises\processesMB.csv" -NoTypeInformation -UseCulture

