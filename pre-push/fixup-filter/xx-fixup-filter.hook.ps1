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

Write-Host "<< fixup-filter, ps-1.1"
Write-Debug "Begin fixup-filter hook"

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
	-MessageRegex "^fixup!"
if ($null -ne $ForbiddenCommitSHA) {
	Write-Host `
		-ForegroundColor Red `
		"Forbidden commit detected — $ForbiddenCommitSHA"
}


Write-Debug "End fixup-filter hook"
exit $HookExitCode
