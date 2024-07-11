$source = "\\file.nchosting.dk\Operations\Team 7\Windows\Installers\Puppet\puppet-agent-x64-latest.msi"
$destination = "C:\Program Files\puppet-agent-x64-latest.msi"
$configPath = "C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf"
$hostname = (Get-WmiObject Win32_ComputerSystem).Name
$ConfigMAIN = @(
    "[main]",
    "certname = agent.example.com",
    "server=puppet.example.com",
    "environment = production",
    "runinterval = 30m",
    "logdir = /var/log/puppetlabs/puppet",
    "vardir = /opt/puppetlabs/puppet/cache",
    "rundir = /var/run/puppetlabs",
    "ssldir = /etc/puppetlabs/puppet/ssl"
)
$ConfigAGENT = @(
    "[agent]",
    "report = true",
    "listen = false",
    "pluginsync = true",
    "masterport = 8140",
    "certname = agent.example.com",
    "environment = production",
    "server = puppet.example.com"
)
$ConfigMASTER = @(
    "[master]",
    "autosign = /etc/puppetlabs/puppet/autosign.conf { mode = 664 }",
    "manifest = /etc/puppetlabs/code/environments/$environment/manifests",
    "modulepath = /etc/puppetlabs/code/environments/$environment/modules:/opt/puppetlabs/puppet/modules"
)


# Copy the .msi file from \\file.nchosting.dk
try {
    Copy-Item -Path $source -Destination $destination
    Write-Host "File copied successfully."
} catch {
    Write-Host "Failed to copy file"
}


#   Installation of Puppet
try {
    $installProcess = Start-Process "msiexec.exe" -ArgumentList "/qn /norestart /i `"$destination`"" -PassThru -Wait
    if ($installProcess.ExitCode -ne 0) {
        throw "Installation failed with exit code $($installProcess.ExitCode)"
    }
    Write-Host "Installation completed"
} catch {
    Write-Host "Installation failed"
}


# Edit the puppet.config file based on hostname
try {
    Clear-Content -Path $configPath
    if (Test-Path $configPath) {
        $configLines = Get-Content $configPath
        if ($hostname -match "KON") {
            $configLines += $ConfigAGENT
        } 
        
        elseif ($hostname -match "ADD") {
            $configLines += $ConfigMAIN
        } 
        
        elseif ($hostname -match "DB") {
            $configLines += $ConfigMASTER
        } 
        
        else {
            Write-Host "Din kode er låååårt"
        }
        $configLines | Set-Content $configPath
        Write-Host "puppet.config file updated"
        } 
        
    else {
        Write-Host "puppet.config file does not exist"
    }
 } catch {
    Write-Host "Failed to update puppet.config file"
 }


#   Delete the MSI file
if (Test-Path $destination) {
  try {
      Remove-Item -Path $destination
      Write-Host "File deleted successfully."
  } catch {
      Write-Host "Failed to delete file"
  }
} else {
  Write-Host "File does not exist."
}