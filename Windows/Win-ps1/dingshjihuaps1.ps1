$computers = Get-Content dingshjihua.txt
#$username = "Administrator"
$username = "管理员账户"
#$username = "user1"
$password = ConvertTo-SecureString "管理员密码" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $password)
$scriptBlockTask = {
    $taskCommand = "PowerShell.exe -ExecutionPolicy Bypass -File D:\copy.ps1"

    # 检查是否已存在名为 "copy-games2" 的计划任务，存在则删除
    $existingTask = SchTasks /Query /TN "copy-games2" /FO CSV | ConvertFrom-Csv
    if ($existingTask -ne $null) {
        SchTasks /Delete /TN "copy-games2" /F
    }

    # 创建新的计划任务
    SchTasks /Create /SC DAILY /TN "copy-games2" /TR "$taskCommand" /ST 10:45 /RL HIGHEST
}

foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer -Credential $cred -ScriptBlock $scriptBlockTask
}