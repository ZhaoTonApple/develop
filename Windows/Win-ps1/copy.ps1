net use X: \\192.168.1.1\d$ "管理员密码" /user:"管理员账户"
robocopy "X:\games\" "d:\games\" /E /XO
net use X: /delete