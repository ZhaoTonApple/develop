$computers = Get-Content "D:\20231023\常用脚本\x86-ip.txt"
#$username = "Administrator"
$username = "管理员账户"
$password = ConvertTo-SecureString "管理员密码" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($username, $password)

$cmd = "route delete 192.168.1.0 mask 255.255.255.0   192.168.2.1  -P"
foreach ($computer in $computers) {
    Write-Host "Configuring static route on $computer"
    Invoke-Command -ComputerName $computer -Credential $cred -ScriptBlock {
        param($cmd)
        Invoke-Expression $cmd
    } -ArgumentList $cmd
}
