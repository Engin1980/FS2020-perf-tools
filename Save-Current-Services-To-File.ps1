$services = Get-Service 

foreach ($service in $services) {
    $infoLine = "{0,-32} : {1,-10} `t # {2}" -f $service.ServiceName, $service.Status, $service.DisplayName 
    $infoLine | Add-Content -Path "R:\services.txt"
}
