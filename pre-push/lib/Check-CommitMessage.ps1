function Check-CommitMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $RemoteRef,

        [Parameter(Mandatory)]
        [string]
        $RemoteSha,

        [Parameter(Mandatory)]
        [string]
        $LocalSha,

        [Parameter(Mandatory)]
        [string]
        $MessageRegex
    )
    
    process {
        $Z40 = "0000000000000000000000000000000000000000"
        $HookExitCode = 0
        $ForbiddenCommitSHA = $null

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
	
                $ForbiddenCommit = (git rev-list --max-count=1 --grep "$MessageRegex" "$Range")
                if ($null -ne $ForbiddenCommit) {
                    Write-Debug "Forbidden commit detected"
                    $HookExitCode = 13
                    $ForbiddenCommitSHA = $ForbiddenCommit
                }
                else {
                    Write-Debug "No forbidden commits detected"
                }
            }
            else {
                Write-Debug "Remote ref/branch is `"unprotected`", NOOP"
            }
        }

        return $HookExitCode, $ForbiddenCommitSHA
    }
}
