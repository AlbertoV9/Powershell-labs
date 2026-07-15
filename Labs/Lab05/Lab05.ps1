function Get-AVProcessReport {

    param (

        [Parameter(Mandatory)]
        [ValidateRange(0, 1.0/0.0)]
        [int]$MemoryLimitMB,

        [string]$OutputPath,

        [switch]$SortDescending,

        [switch]$PassThru
    )

#Gather all the processes
$processes = Get-Process |
#Filter the ones above the memory limit, translate the given int to MB
                 Where-Object {$_.WorkingSet -gt $MemoryLimitMB*1MB} |
#Sort in descending order based on WorkingSet property
                     Sort-Object -Property WorkingSet -Descending:$SortDescending |
#Show only the Name, Id, CPU, WorkingSetMB calculated property
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
if ($OutputPath) { try
    {$processes | Export-csv -Path "$($OutputPath)\ProcessesRaport.csv" -UseCulture -NoTypeInformation
    Write-Output "File successfuly saved"
    if ($PassThru) {Write-Output $processes}
                 }catch{Write-Output "Failed to save the file - $($_.Exception.Message)"} } 
else {
    $processes
}

}


Get-AVProcessReport -MemoryLimitMB 100 -OutputPath "C:\Users\averna\OneDrive - Capgemini\Desktop" 



