# Composite pre-push hook

## Installation

- Place wrapping `pre-push` and `pre-push.ps` scripts inside your repository hooks directory
- Place concrete hooks inside `pre-push.d` directory inside your repository hooks directory

Hooks inside `pre-push.d` are ordered by name and executed one after another.

If all hooks completed with zero exit code, composite hook completes with zero exit code. First failed, that is, completed with non-zero exit code, hook prevents consequent hooks from execution. And composite hook completes with non-zero exit code.