$ipList = Get-Content "D:\20231023\常用脚本\ping-ip.txt"

foreach ($ip in $ipList) {
    $result = Test-Connection -ComputerName $ip -Count 1 -Quiet

    if (-not $result) {
        Add-Content -Path "D:\20231023\常用脚本\ping-error.log" -Value "$ip is not reachable"
    }
}