$path = "R:\services2.txt"
$data = Get-Content -Path $path
foreach ($line in $data) {
    $hashIndex = $line.IndexOf("#");
    if ($line.IndexOf("#") -lt 0) {
        $tmp = $line
    }
    else {
        $tmp = $line.Substring(0, $hashIndex)
    }
    $tmp = $tmp.Split(":")
    $serviceName = $tmp[0].Trim()
    $serviceState = $tmp[1].Trim()
    Write-Host($serviceName + " : " + $serviceState)

    Write-Host("Obtaining service {0}" -f $serviceName)
    $service = Get-Service -Name $serviceName
    Write-Host("  ... current state: {0}, desired state: {1}" -f $service.Status, $serviceState)
    if ($service.Status -ne $serviceState) {
        if ($serviceState -eq "Running") {
            Write-Host("  ... starting")
            try {
                Start-Service $service  -ErrorAction Stop  
                Write-Host("  ... ... started")
                Write-Host("  ... ... {0}" -f $service.Status)
            }
            catch {
                Write-Host("  ... ... FAILED, {0}" -f $_.Exception.Message)
            }
        }
        elseif ($serviceState -eq "Stopped") {
            Write-Host("  ... stopping")
            try {
                Stop-Service $service -ErrorAction Stop
                Write-Host("  ... stopped")
                Write-Host("  ... {0}" -f $service.Status)
            } 
            catch {
                Write-Host("  ... ... FAILED, {0}" -f $_.Exception.Message)
            }
        }
    }
}
