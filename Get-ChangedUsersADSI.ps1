$Credential = Import-Clixml -Path "$PSScriptRoot\Credential.xml"

$DCContext = [System.DirectoryServices.ActiveDirectory.DirectoryContext]::new(
    'DirectoryServer',
    'demo.psconf.local',
    $Credential.UserName,
    $Credential.GetNetworkCredential().Password
)
$DomainController = [System.DirectoryServices.ActiveDirectory.DomainController]::GetDomainController( $DCContext )

$HighestUSN = $DomainController.HighestCommittedUsn

if ( -not $LowestUSN ) {
    $LowestUSN = 0
}

# uSNChanged / uSNCreated

Write-Host "Fetching users with uSNChanged between $LowestUSN and $HighestUSN (ADSI)..." -ForegroundColor Cyan

$Searcher = $DomainController.GetDirectorySearcher()
$Searcher.Filter = "(&(uSNChanged>=$LowestUSN)(uSNChanged<=$HighestUSN)(objectClass=person)(objectCategory=user))"
$Searcher.PropertiesToLoad.AddRange( @( 'Name', 'uSNCreated', 'uSNChanged' ) )
$Searcher.FindAll().ForEach({

    [pscustomobject]@{
        Name = $_.Properties['Name'][0]
        uSNCreated = $_.Properties['uSNCreated'][0]
        uSNChanged = $_.Properties['uSNChanged'][0]
    }

})

$LowestUSN = $HighestUSN + 1