function Get-ProcessReport {

    param (

        [Parameter(Mandatory)]
        [int]$MemoryLimitMB,

        [string]$OutputPath,

        [switch]$SortDescending
    )

#Gather all the processes
$processes = Get-Process |
#Filter the ones above the memory limit, translate the given int to MB
                 Where-Object {$_.WorkingSet -gt $MemoryLimitMB*1MB} |
#Sort in descending order based on WorkingSet property
                     Sort-Object -Property WorkingSet -Descending:$SortDescending |
#Show only the Name, Id, CPU, WorkingSetMB calculated property, Checked at calculated property
                        Select-Object -Property Name, Id, CPU, 
                             @{
                                Name = "WorkingSetMB"
                                Expression = {
                                     [math]::Round(($_.WorkingSet/1MB), 2)
                                    }
                            },
                             @{
                                 Name = "CheckedAt"
                                 Expression = {
                                     Get-Date -Format "dd-MM-yyyy HH:mm"
                                    }
                            }
#If OutputPath is provided, export the outcome to the csv in the path, if not, return the result
if ($OutputPath) {$processes | Export-csv -Path "$($OutputPath)\ProcessesRaport.csv" -UseCulture -NoTypeInformation} else {
    return $processes
}

}

#Save the function objects to a variable and pipe into exporting to csv
$report = Get-ProcessReport -MemoryLimitMB 250 
$report | Export-csv -Path "C:\Users\averna\OneDrive - Capgemini\Desktop\Psh AZ 104 scripts\Psh exercises\raportprocesses.csv" -NoTypeInformation -UseCulture

<# Get-ProcessReport -MemoryLimitMB 200 -OutputPath "C:\Users\averna\OneDrive - Capgemini\Desktop" #>