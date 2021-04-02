# WIP-commits filter pre-push hook

Adapted from sample git pre-push hook to be used with PowerShell Core.
Hook simply does not allow pushing into `master` and `main` branches any
commits with messages starting with `!` (exclamation mark).



First version posted [here](https://gist.github.com/IlyaVassyutovich/e0b6c3387cc2e395137ee4c048f46c0c).