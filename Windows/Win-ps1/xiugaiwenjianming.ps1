# 从文件中读取远程主机的 IP 地址
$hostsFilePath = "D:\20231023\常用脚本\xiugaiwenjianming.txt"
$remoteHosts = Get-Content $hostsFilePath

# 远程主机管理员账户名和密码
$remoteUsername = "管理员账户"
$remotePassword = ConvertTo-SecureString "管理员密码" -AsPlainText -Force
$remoteCred = New-Object System.Management.Automation.PSCredential ($remoteUsername, $remotePassword)

# 遍历远程主机进行操作
foreach ($remoteHost in $remoteHosts) {
    Write-Host "正在连接到远程主机 $remoteHost..."
    $session = New-PSSession -ComputerName $remoteHost -Credential $remoteCred

    # 执行在远程主机上的命令
    Invoke-Command -Session $session -ScriptBlock {
        $oldPath = "D:\games\test1"
        $newPath = "D:\games\test2"

        # 检查文件是否存在，存在则重命名
        if (Test-Path $oldPath) {
            Rename-Item -Path $oldPath -NewName $newPath -Force
            Write-Host "在远程主机 $using:remoteHost 上成功将文件名修改为 test2"
        } else {
            Write-Host "在远程主机 $using:remoteHost 上找不到文件名为 test1 的文件。"
        }
    }

    # 关闭会话
    Remove-PSSession -Session $session
}