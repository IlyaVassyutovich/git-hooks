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

$DebugPreference = "SilentlyContinue"
$ErrorActionPreference = "Stop"

Write-Host "<< wip-filter, ps-3.1"
Write-Debug "Begin wip-filter hook"

. (Join-Path $PSScriptRoot "./lib/Check-CommitMessage.ps1")


$SuppliedParams = @{
	RemoteName = $RemoteName;
	PushUri = $PushUri;

	LocalRef = $LocalRef;
	LocalSha = $LocalSha;

	RemoteRef = $RemoteRef;
	RemoteSha = $RemoteSha;
}
Write-Debug "Supplied params"
Write-Debug ($SuppliedParams | Out-String)


$HookExitCode, $ForbiddenCommitSHA = Check-CommitMessage `
	-RemoteRef $RemoteRef `
	-RemoteSha $RemoteSha `
	-LocalSha $LocalSha `
	-MessageRegex "^!"
if ($null -ne $ForbiddenCommitSHA) {
	Write-Host `
		-ForegroundColor Red `
		"Forbidden commit detected — $ForbiddenCommitSHA"
}


Write-Debug "End wip-filter hook"
exit $HookExitCode
