[CmdletBinding()]
param (
	[Parameter(Mandatory)]
	[string]
	$HookDir,

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

Write-Host "<< pre-push composite-hook, ps-1.0"
Write-Debug "Working dir: $pwd"
$HookDir = Resolve-Path $HookDir
Write-Debug "Hook dir; $HookDir"
Write-Debug "Begin pre-push composite-hook"

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

$CompositeHookExitCode = 0

$PrePushHooksDirectory = Join-Path $HookDir "pre-push.d"
if (Test-Path $PrePushHooksDirectory -PathType Container) {
	Write-Debug "Found pre-push hooks directory"
	$PrePushHooks = Get-ChildItem $PrePushHooksDirectory `
		| Where-Object -Property Name -Match ".+\.hook\.ps1$" `
		| Sort-Object -Property Name

	if ($PrePushHooks.Count -gt 0) {
		Write-Debug "Got $($PrePushHooks.Count) hook(-s) to execute"

		foreach ($HookFile in $PrePushHooks) {
			Write-Debug "Executing `"$HookFile`""

			# This is just hideous! Well, pwsh!
			$HookParams = @{
				RemoteName = $RemoteName;
				PushUri = $PushUri;
				LocalRef = $LocalRef;
				LocalSha = $LocalSha;
				RemoteRef = $RemoteRef;
				RemoteSha = $RemoteSha;
			}
			& $HookFile @HookParams
			$HookExitCode = $LASTEXITCODE
			
			Write-Debug "Executed `"$HookFile`""

			if ($HookExitCode -eq 0) {
				Write-Debug "Hook completed successfully"
			}
			elseif ($null -eq $HookExitCode) {
				throw "Hook did not set exit code upon completion."
			}
			else {
				Write-Warning "<< Hook exited with exit code `"$HookExitCode`"."
				Write-Warning "<< No more hooks will be executed."
				$CompositeHookExitCode = $HookExitCode
				break
			}
		}
	}
	else {
		Write-Warning "<< found no pre-push hooks."
	}
}
else {
	Write-Warning "<< pre-push hooks directory not found."
}

Write-Debug "End pre-push composite-hook"
exit $CompositeHookExitCode
