#Get the services running on the device
$services = Get-Service |
#Filter the services to the ones in Running status and Name starting with W
                Where-Object {$_.Status -eq "Running" -and $_.Name -like "W*"} |
#Sort them in descending order as per alphabet
                    Sort-Object
#Filter the properties for Name, DisplayName and Status and calculated property showing the timestamp of the check
$services = $services | Select-Object -Property Name, DisplayName, Status, 
                @{
                    Name = "CheckedAt"
                    Expression = {Get-Date -Format "dd-MM-yyyy HH:mm"}
                }
#Export to csv
$services | Export-csv "C:\Users\averna\OneDrive - Capgemini\Desktop\Psh AZ 104 scripts\services.csv" -NoTypeInformation -UseCulture

if ($services.count -eq 0) {
    Write-Host "No services found"
}
