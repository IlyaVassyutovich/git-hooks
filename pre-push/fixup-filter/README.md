# FIXUP!-commits filter pre-push hook

Adapted from sample git pre-push hook to be used with PowerShell Core.
Hook simply does not allow pushing into `master` and `main` branches any
commits with messages starting with `fixup!`.
