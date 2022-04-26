param( [uint32]$Count = 1 )

$ErrorActionPreference = 'Continue'

$ADSplat = @{
    Credential = Import-Clixml -Path "$PSScriptRoot\Credential.xml"
    Server = 'demo.psconf.local'
}

$FirstNames = Get-Item -Path "$PSScriptRoot\data\firstnames*.csv" | ForEach-Object { Import-Csv -Path $_.FullName } | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_.'Given Name'.tolower()) }
$LastNames = Import-Csv -Path "$PSScriptRoot\data\surnames.csv" | ForEach-Object { (Get-Culture).TextInfo.ToTitleCase($_.'Surnames'.tolower()) }

1..$Count | ForEach-Object {

    $GivenName = $FirstNames | Select-Object -Index ( Get-Random -Maximum $FirstNames.Count )
    $Surname = $LastNames | Select-Object -Index ( Get-Random -Maximum $LastNames.Count )

    $DisplayName = $GivenName, $Surname -join ' '

    New-ADUser -Name $DisplayName -DisplayName $DisplayName -GivenName $GivenName -Surname $Surname @ADSplat

}