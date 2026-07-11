#Get the processes and filter based on workingset properties in MB greater than 100MB and CPU usage greater than 10 and sort it descending based on WS
$processes = Get-Process | 
                 Where-Object {$_.WorkingSet -ge 100MB -and $_.CPU -ge 10} | 
                     Sort-Object -Property WS -Descending | 
                         Select-Object -Property Name, Id, CPU,
                             @{
                                Name = "WorkingSetMB"
                                Expression = {

                                    [math]::Round(($_.WorkingSet/1MB), 2)
                                }
                             } 
     
$processes | Export-Csv -path "C:\Users\Alberto\Desktop\Pwsh labs\powershellexcel.csv" -NoTypeInformation