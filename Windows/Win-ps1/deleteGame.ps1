$ipList = Get-Content "deleteGame-ip.txt"
$username = "管理员账户"
$password = ConvertTo-SecureString "管理员密码" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($username, $password)

foreach ($ip in $ipList) {
    Invoke-Command -ComputerName $ip -Credential $credential -ScriptBlock {
        Remove-Item -Path 'D:\games\test\Minecraft Dungeons' -Recurse -Force
        Remove-Item -Path 'D:\games\test\NBA 2K23' -Recurse -Force
    }
    
    Write-Host "Deleted Marvels SpiderMan Remastered folder on $ip"
}

