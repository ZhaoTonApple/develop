$ipFile = "D:\20231023\常用脚本\chuanshuwenjian.txt"
$pcNameFile = "pcname.txt"
$username = "管理员账户"
$password = "管理员密码"

$ips = Get-Content $ipFile
$pcNames = Get-Content $pcNameFile

if ($ips.Count -ne $pcNames.Count) {
    Write-Host "IP 数量与主机名数量不匹配"
    exit
}


$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePassword

foreach($ip in $ips) {
    $pcName = $pcNames[$ips.IndexOf($ip)]

    $session = New-PSSession -ComputerName $ip -Credential $credential

    Invoke-Command -Session $session -ArgumentList $pcName -ScriptBlock {
        param($newName)
        Rename-Computer -NewName $newName -Force
        $sysInfo = Get-WmiObject -Class Win32_ComputerSystem
        $sysInfo.JoinDomainOrWorkGroup($newName)
    }
    
    Remove-PSSession -Session $session
}