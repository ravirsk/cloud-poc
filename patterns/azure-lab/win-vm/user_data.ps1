#
# Reference: https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/iis/?view=aspnetcore-3.1
#
# Quick way to download the Windows Hosting Bundle and Web Deploy installers which may
# then be executed on the VM ...
#
#
# Set path where installer files will be downloaded ...
#
#[CmdletBinding()]
#param 
#( 
#    [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$Domain_DNSName,
#)
# Install IIS
#Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools

$temp_path = "C:\temp\"

$ErrorActionPreference = "Stop"
$sampleAppSiteName = "SampleApp"
$defaultDeployDrive = "E:\"
if (!(Test-Path $defaultDeployDrive)) {
    $defaultDeployDrive=$env:systemdrive
}
$binariesDir = "$defaultDeployDrive\$sampleAppSiteName"
$appPort=8080
$fqdn=[System.Net.Dns]::GetHostByName(($env:computerName)).HostName

if( ![System.IO.Directory]::Exists( $temp_path ) )
{
   New-Item -ItemType Directory -Force -Path $temp_path
   Write-Output "Path not found ($temp_path), created the directory"

   Break

}

#
# Download the Windows Hosting Bundle Installer for ASP.NET Core 3.1 Runtime (v3.1.0)
#
# The installer URL was obtained from:
# https://dotnet.microsoft.com/download/dotnet-core/thank-you/runtime-aspnetcore-3.1.0-windows-hosting-bundle-installer
#
#
#$whb_installer_url = "https://download.visualstudio.microsoft.com/download/pr/fa3f472e-f47f-4ef5-8242-d3438dd59b42/9b2d9d4eecb33fe98060fd2a2cb01dcd/dotnet-hosting-3.1.0-win.exe"

#$whb_installer_url = "https://download.visualstudio.microsoft.com/download/pr/d489c5d0-4d0f-4622-ab93-b0f2a3e92eed/101a2fae29a291956d402377b941f401/dotnet-hosting-7.0.10-win.exe"

#OR
#$temp_path = "C:\temp1"
#$wh_installer_url = "https://dotnet.microsoft.com/permalink/dotnetcore-current-windows-runtime-bundle-installer"
#$wh_installer_file = $temp_path + [System.IO.Path]::GetFileName( $wh_installer_url )
#Invoke-WebRequest -Uri $wh_installer_url -OutFile $wh_installer_file


#$whb_installer_file = $temp_path + [System.IO.Path]::GetFileName( $whb_installer_url )
#Write-Output "Path ($whb_installer_file)"

#Try
#{
#   Write-Output "Invoking Web Request"
#   Invoke-WebRequest -Uri $whb_installer_url -OutFile $whb_installer_file

#   Write-Output ""
#   Write-Output "Windows Hosting Bundle Installer downloaded"
#   Write-Output "- Execute the $whb_installer_file to install the ASP.Net Core Runtime"
#   Write-Output ""

#}
#Catch
#{
#  Write-Output ( $_.Exception.ToString() )
#  Break
#}

#
# Download Web Deploy v3.6
#
# The installer URL was obtained from:
# https://www.iis.net/downloads/microsoft/web-deploy
# x86 installer: https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_x86_en-US.msi
# x64 installer: https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi
#

#$wd_installer_url = "https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi"

#$wd_installer_file = $temp_path + [System.IO.Path]::GetFileName( $wd_installer_url )

#Try
#{

#   Invoke-WebRequest -Uri $wd_installer_url -OutFile $wd_installer_file

#   Write-Output "Web Deploy installer downloaded"
#   Write-Output "- Execute $wd_installer_file and choose the [Complete] option to install all components"
#   Write-Output ""

#}
#Catch
#{
#   Write-Output ( $_.Exception.ToString() )
#   Break
#}

#Invoke-WebRequest -Uri https://github.com/ravirsk/cloud-poc/blob/feature-01/IIS-WebaApp/blazorapp.zip -OutFile "C:\temp\blazorapp.zip"
#Expand-Archive -Path C:\temp\blazorapp.zip -DestinationPath C:\blazorapp

#$zipURI = "https://github.com/ravirsk/cloud-poc/blob/feature-01/IIS-WebaApp/blazorapp.zip"
#(New-Object System.Net.WebClient).DownloadFile( $zipURI, C:\temp\blazorapp.zip)
#New-Item iis:\\Sites\blazorapp -bindings @{protocol="http", binding }

# URL and Destination

#$url = "https://github.com/ravirsk/cloud-poc/blob/feature-01/IIS-WebaApp/sampleApp.ps1"
#$dest = "C:\temp\sampleApp.ps1"
# Download file
#Invoke-WebRequest -Uri $url -OutFile $dest 

#Write-Output "STARTING-INSTALLATION ....."
#$scriptPath = 'C:\temp\sampleApp.ps1'
#. $scriptPath




function Install-IIS {
	Write-Host "Installing IIS..."
	Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
	Write-Host "Installed IIS..."
}

function Install-DotnetSdk {
    Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -OutFile 'dotnet-install.ps1'
    .\dotnet-install.ps1 -Channel 7.0 -Version latest
	Write-Host "Installed Dotnet SDK..."
}

function Install-HostingBundle {
    #if (Test-Path "C:\Program Files\IIS\Asp.Net Core Module\V2\") {
        #if (!(Test-Path "C:\Program Files\IIS\Asp.Net Core Module\V2\17.0.23196"))
        #{
        Invoke-WebRequest 'https://download.visualstudio.microsoft.com/download/pr/d489c5d0-4d0f-4622-ab93-b0f2a3e92eed/101a2fae29a291956d402377b941f401/dotnet-hosting-7.0.10-win.exe' -OutFile 'dotnet-hosting-7.0.10-win.exe'
        Start-Process -Wait '.\dotnet-hosting-7.0.10-win.exe' -ArgumentList 'OPT_NO_RUNTIME=1 OPT_NO_SHAREDFX=1 OPT_NO_X86=1 /install /quiet /norestart'
        net stop was /y
        net start w3svc
        #}
    #} else {Write-Host "IIS not installed in default location"}
	Write-Host "Installed-HostingBundle..."
}

function Create-WebSite {
if ((Get-Website -Name "$sampleAppSiteName").Id -eq $null) {
	Write-Host "Creating WebSite..."
    if (Test-Path "IIS:\AppPools\$sampleAppSiteName") { Remove-WebAppPool -Name "$sampleAppSiteName" }
    if (Test-Path "$binariesDir") { Remove-Item -Force -Recurse -Path "$binariesDir" }
    New-WebAppPool -Name "$sampleAppSiteName"
    Set-ItemProperty "IIS:\AppPools\$sampleAppSiteName" -Name managedRuntimeVersion -Value ""
    Set-ItemProperty "IIS:\AppPools\$sampleAppSiteName" -Name autoStart -Value $false
    New-Item -Path "$binariesDir" -Type Directory | Out-Null
    $sslCertThumbprint=(New-SelfSignedCertificate -Subject "$fqdn" -CertStoreLocation "CERT:LocalMachine\My").Thumbprint
    New-IISSite -Name "$sampleAppSiteName" -BindingInformation "*:${appPort}:" -PhysicalPath "$binariesDir" -CertificateThumbPrint "$sslCertThumbprint" -CertStoreLocation "Cert:\LocalMachine\My" -Protocol https
    Set-ItemProperty "IIS:\Sites\$sampleAppSiteName" -Name applicationpool -Value $sampleAppSiteName
	Write-Host "Created WebSite..."
}
}

function Create-BlazorApp {
    if (!(Test-Path ".\$sampleAppSiteName.csproj")) {
    dotnet new blazorserver -n $sampleAppSiteName -o . 
    }
}

function Build-App {
	Write-Host "Building App..."
    dotnet publish -c Release -r win-x64 --self-contained true -o "$binariesDir"
}

function Restart-WebApp {
Stop-WebAppPool -Name $sampleAppSiteName -ErrorAction SilentlyContinue
do
    {
        Write-Host (Get-WebAppPoolState $sampleAppSiteName).Value
        Start-Sleep -Seconds 1
    }
    until ( (Get-WebAppPoolState -Name $sampleAppSiteName).Value -eq "Stopped" )
    Start-WebAppPool -Name $sampleAppSiteName
    Write-Host "$sampleAppSiteName Started"
}
#TBD
function DeployApp-FromRepo {
	Write-Host "Deploying App From Repo ..."

	# URL and Destination
	$url = "https://github.com/ravirsk/cloud-poc/blob/feature-01/IIS-WebaApp/blazorapp.zip"
	$dest = "C:\temp\blazorapp.zip"
	# Download file
	Invoke-WebRequest -Uri $url -OutFile $dest
	Expand-Archive -Path C:\temp\blazorapp.zip -DestinationPath C:\blazorapp	
}


Install-IIS
Install-DotnetSdk
Install-HostingBundle
Create-WebSite
Create-BlazorApp
Build-App
Restart-WebApp




