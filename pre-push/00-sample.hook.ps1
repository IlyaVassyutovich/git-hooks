[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[string]
	$RemoteName,

	[Parameter(Mandatory)]
	[string]
	$PushUri,

	[Parameter(Mandatory)]
	[string]
	$LocalRef,

	[Parameter(Mandatory)]
	[string]
	$LocalSha,

	[Parameter(Mandatory)]
	[string]
	$RemoteRef,

	[Parameter(Mandatory)]
	[string]
	$RemoteSha
)

$ErrorActionPreference = "Stop"

Write-Host "<< sample, ps-1.0"
Write-Host "Hello from sample hook!"
Write-Host "I was called with following parameters:"
$SuppliedParams = @{
	RemoteName = $RemoteName;
	PushUri = $PushUri;

	LocalRef = $LocalRef;
	LocalSha = $LocalSha;

	RemoteRef = $RemoteRef;
	RemoteSha = $RemoteSha;
}
$SuppliedParams | Format-Table

exit 0
