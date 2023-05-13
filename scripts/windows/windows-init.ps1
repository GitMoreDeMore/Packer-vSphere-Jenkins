$ErrorActionPreference = "Stop"

# Set the Windows Remote Management configuration.
Write-Output "Setting the Windows Remote Management configuration..."
Enable-PSRemoting -Force
winrm quickconfig -q
winrm quickconfig -transport:http
winrm set winrm/config '@{MaxTimeoutms="1800000"}'
winrm set winrm/config/winrs '@{MaxMemoryPerShellMB="800"}'
winrm set winrm/config/service '@{AllowUnencrypted="true"}'
winrm set winrm/config/service/auth '@{Basic="true"}'
winrm set winrm/config/client/auth '@{Basic="true"}'
winrm set winrm/config/listener?Address=*+Transport=HTTP '@{Port="5985"}'

# Turn off Windows Firewall.
Write-Output "Turning off Windows Firewall..."
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

# Restart Windows Remote Management service.
Write-Output "Restarting Windows Remote Management service..."
Set-Service winrm -startuptype "auto"
Restart-Service winrm