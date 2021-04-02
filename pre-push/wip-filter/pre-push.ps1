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

Write-Host "<< pre-push hook, ps-2.2"
Write-Debug "Begin pre-push hook"

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

$Z40 = "0000000000000000000000000000000000000000"
$HookExitCode = 0

if ($LocalSha -eq $Z40) {
	Write-Debug "Local sha is null, handling `"delete`", NOOP"
}
else {
	Write-Debug "Local sha is not null"

	if ($RemoteRef -eq "refs/heads/master" -or $RemoteRef -eq "refs/heads/main") {
		Write-Debug "Handling push to $RemoteRef"
		if ($RemoteSha -eq $Z40) {
			Write-Debug "Remote sha is null"
			$Range = $LocalSha
		}
		else {
			Write-Debug "Remote sha is not null — setting range"
			$Range = "$RemoteSha..$LocalSha"
		}
		Write-Debug "Range is `"$Range`""
	
		$ForbiddenCommit = (git rev-list --max-count=1 --grep "^!" "$Range")
		if ($null -ne $ForbiddenCommit) {
			Write-Debug "Forbidden commit detected"
			Write-Error "Push rejected for commit `"$ForbiddenCommit`""
			Write-Debug "End pre-push hook"
			$HookExitCode = 13
		}
		else {
			Write-Debug "No forbidden commits detected"
		}
	}
	else {
		Write-Debug "Remote ref/branch is `"unprotected`", NOOP"
	}
}

Write-Debug "End pre-push hook"
exit $HookExitCode
