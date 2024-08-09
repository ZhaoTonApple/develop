$Username = '管理员账户'
$Password = '密码'
$pass=ConvertTo-SecureString -String $Password -AsPlainText -Force
$cred=New-Object pscredential($Username, $pass)


#服务器ip地址
$serverIPFile = "ip.txt"
# 指定目标目录路径
$targetDirectory = "D:\games\"

# 创建一个多行文本文件
$text1 = @"
192.168.1.1
"@
# 将文本保存到文件
$text1 | Set-Content -Path $serverIPFile

# 从 ip.txt 文件中读取服务器的 IP 地址列表
$serverIPs = Get-Content -Path $serverIPFile

# 远程执行命令
$scriptblock = {
    param (
        $targetDirectory,
        $ipAddress
    )

    # 获取目录的大小（以字节为单位）
    $directorySize = (Get-ChildItem -Path $targetDirectory -Recurse | Measure-Object -Property Length -Sum).Sum

    # 将大小转换为更友好的格式（例如 MB 或 GB）
    $directorySizeMB = $directorySize / 1MB
    $directorySizeGB = $directorySize / 1GB

    # 返回结果
    $result = @{
        "IPAddress" = $ipAddress
        "Directory" = $targetDirectory
        "SizeBytes" = $directorySize
        "SizeMB" = $directorySizeMB
        "SizeGB" = $directorySizeGB
    }

    return $result
}
  

# 遍历服务器 IP 地址列表并拷贝文件
foreach ($serverIP in $serverIPs) {
    # 去除可能的空格或换行符
    $remoteComputer = $serverIP.Trim()  
    
    # 使用 New-PSSession 建立远程会话
    $session = New-PSSession -ComputerName $remoteComputer -Credential $cred
    # 在远程计算机上执行脚本块
    $remoteResult = Invoke-Command -Session $session -ScriptBlock $scriptblock -ArgumentList $targetDirectory,$serverIP

    # 显示远程结果
    echo "================="
    $remoteResult

    #Remove-PSSession $session
      
}