[CmdletBinding()]
param (
	[Parameter(Mandatory = $True)]
	[String]
	$RepositoryPath
)

$CurrentErrorAction = $ErrorActionPreference
$ErrorActionPreference = "Stop"

try {
	$RepositoryGitHooksDir = Join-Path $RepositoryPath "./.git" "./hooks"
	if (-not (Test-Path $RepositoryGitHooksDir -PathType Container)) {
		throw "Invalid `$RepositoryPath"
	}

	Write-Host "Intalling `"wip-filter`"-hook"
	
	$Root = $PSScriptRoot
	
	Write-Debug "Installing bash entrypoint"
	New-Item `
		-ItemType SymbolicLink `
		-Path (Join-Path $RepositoryGitHooksDir "./pre-push") `
		-Value (Join-Path $Root "./pre-push") `
			| Out-Null
	
	Write-Debug "Installing pwsh entrypoint"
	New-Item `
		-ItemType SymbolicLink `
		-Path (Join-Path $RepositoryGitHooksDir "./pre-push.ps1") `
		-Value (Join-Path $Root "./pre-push.ps1") `
			| Out-Null
	
	Write-Debug "Initializing hooks directory"
	$PrePushDirectory = Join-Path $RepositoryGitHooksDir "./pre-push.d"
	New-Item `
		-ItemType Directory `
		-Path $PrePushDirectory `
			| Out-Null
	
	Write-Debug "Installing library/helpers"
	New-Item `
		-ItemType SymbolicLink `
		-Path (Join-Path $PrePushDirectory "./lib") `
		-Value (Join-Path $Root "./lib") `
			| Out-Null
	
	Write-Debug "Installing `"wip-filter`"-hook"
	New-Item `
		-ItemType SymbolicLink `
		-Path (Join-Path $PrePushDirectory "./01-wip-filter.hook.ps1") `
		-Value (Join-Path $Root "./wip-filter" "./xx-wip-filter.hook.ps1") `
			| Out-Null
	
	Write-Host "Successfully installed `"wip-filter`"-hook for `"$RepositoryPath`""
}
finally {
	$ErrorActionPreference = $CurrentErrorAction
}
