$computers = Get-Content "D:\20231023\ýű\reboot-PC-ip.txt"

foreach ($computer in $computers) {
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "管理员账号", (ConvertTo-SecureString "密码" -AsPlainText -Force)
    
    try {
        Invoke-Command -ComputerName $computer -Credential $credential -ScriptBlock {
            Shutdown.exe /r /f /t 0
        }
    } catch {
        Write-Host "Error connecting to ${computer}: $_"
    }
}