# 设置执行策略为 RemoteSigned
Set-ExecutionPolicy RemoteSigned -Scope Process -Force

# 读取存储IP地址的文件
$ipAddresses = Get-Content "D:\20231023\常用脚本\chuanshuwenjian.txt"

# 待传输的本地文件路径
$localFilePath = "D:\20231023\镜像模板制作\快手\IddSampleDriver.rar"

# 远程主机的用户名和密码
$username = "管理员账户"
$password = ConvertTo-SecureString "管理员密码" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

# 连接每台远程主机并传输文件
foreach ($ipAddress in $ipAddresses) {
    $session = New-PSSession -ComputerName $ipAddress -Credential $credential
    Copy-Item -Path $localFilePath -Destination "D:\" -ToSession $session
    Remove-PSSession $session
}
###################################### 
## 设置执行策略为 RemoteSigned
#Set-ExecutionPolicy RemoteSigned -Scope Process -Force
#
## 读取存储IP地址的文件
#$ipAddresses = Get-Content "D:\20231023\常用脚本\chuanshuwenjian.txt"
#
## 待传输的本地文件路径
##$localFilePath1 = "D:\20231023\11_10_9\9-test\gsdaemon.ini"
##$localFilePath2 = "D:\20231023\11_10_9\9-test\update.ini"
#$localFilePath2 = "D:\20231023\常用脚本\copy.ps1"
#
## 远程主机的用户名和密码
#$username = "管理员账户"
#$password = ConvertTo-SecureString "管理员密码" -AsPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential($username, $password)
#
## 连接每台远程主机并传输文件
#foreach ($ipAddress in $ipAddresses) {
#    $session = New-PSSession -ComputerName $ipAddress -Credential $credential
#    Copy-Item -Path $localFilePath2 -Destination "D:\copy.ps1" -ToSession $session -Force
#    #Copy-Item -Path $localFilePath1 -Destination "D:\FunStream1\etc\update.ini" -ToSession $session -Force
#    Remove-PSSession $session
#}



#################################
## 设置执行策略为 RemoteSigned
#Set-ExecutionPolicy RemoteSigned -Scope Process -Force
#
## 读取存储IP地址的文件
#$ipAddresses = Get-Content "D:\20231023\常用脚本\yuancheng-ip.txt.bak"
#
## 待传输的本地文件路径
#$localFilePath = "D:\20231023\中文注册器.exe"
#$remoteDirectory = "D:\games\Need for Speed Rivals\" # 远程主机目标目录
#
## 远程主机的用户名和密码
#$username = "管理员账户"
#$password = ConvertTo-SecureString "管理员密码" -AsPlainText -Force
#$credential = New-Object System.Management.Automation.PSCredential($username, $password)
#
## 连接每台远程主机并传输文件到目标目录
#foreach ($ipAddress in $ipAddresses) {
#    $session = New-PSSession -ComputerName $ipAddress -Credential $credential
#    Copy-Item -Path $localFilePath -Destination $remoteDirectory -ToSession $session
#    Remove-PSSession $session
#}
#
## 远程主机执行文件
#foreach ($ipAddress in $ipAddresses) {
#    $session = New-PSSession -ComputerName $ipAddress -Credential $credential
#    Invoke-Command -Session $session -ScriptBlock {
#        $executablePath = Join-Path $using:remoteDirectory "中文注册器.exe"
#        Start-Process -FilePath $executablePath -NoNewWindow -Wait
#    }
#    Remove-PSSession $session
#}