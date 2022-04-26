$env:ADPS_LoadDefaultDrive = 0

$ADSplat = @{
    Credential = Import-Clixml -Path "$PSScriptRoot\Credential.xml"
    Server = 'demo.psconf.local'
}

$RootDSE = Get-ADRootDSE @ADSplat

$HighestUSN = $RootDSE.highestCommittedUSN

if ( -not $Global:LowestUSN ) {
    $Global:LowestUSN = 0
}

Write-Host "Fetching users with uSNChanged between $LowestUSN and $HighestUSN..." -ForegroundColor Cyan

Get-ADUser -Filter "uSNChanged -gt $LowestUSN -and uSNChanged -le $HighestUSN" -Properties uSNChanged, uSNCreated @ADSplat |
    Select-Object Name, uSNCreated, uSNChanged

$Global:LowestUSN = $HighestUSN