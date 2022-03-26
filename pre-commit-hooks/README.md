## pre-commit hooks

A collection of pre-commit hooks to use in Nasqueron projects.

### ShellCheck

Initial authors: 06kellyjac, Mark Butcher and Yevgeniy Brikman.

To enable optional shellcheck features you can use the `--enable` flag.
Other shellcheck flags can not be passed through.

```yaml
repos:
  - repo: https://github.com/nasqueron/codestyle
    rev: 0.1.0
    hooks:
      - id: shellcheck
        args: ["--enable require-variable-braces,deprecate-which"]
```
