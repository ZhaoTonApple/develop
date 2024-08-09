$computers = Get-Content kuaishou-ip.txt
$username = "管理员账户"
$password = ConvertTo-SecureString "管理员密码" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $password)
$scriptBlockDeleteTask = {
    SchTasks /Delete /TN "copy-games2" /F
}

foreach ($computer in $computers) {
    try {
        Invoke-Command -ComputerName $computer -Credential $cred -ScriptBlock $scriptBlockDeleteTask -ErrorAction Stop
    } catch {
        Write-Host "无法连接到远程主机 ${computer}: $($Error[0].Exception.Message)"
        continue
    }
}
