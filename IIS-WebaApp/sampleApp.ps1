$ErrorActionPreference = "Stop"
$sampleAppSiteName = "SampleApp"
$defaultDeployDrive = "E:\"
if (!(Test-Path $defaultDeployDrive)) {
    $defaultDeployDrive=$env:systemdrive
}
$binariesDir = "$defaultDeployDrive\$sampleAppSiteName"
$appPort=8080
$fqdn=[System.Net.Dns]::GetHostByName(($env:computerName)).HostName

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