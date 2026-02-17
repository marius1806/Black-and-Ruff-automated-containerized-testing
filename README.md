# Black-and-Ruff-automated-containerized-testing

## Problem

In many small teams and startups, code quality checks (formatting, linting, testing) are either:
1. Run manually
2. Inconsistent between developers
3. Dependent on local environments
4. Or missing entirely

This leads to:
1. Broken builds
2. Inconsistent style
3. Delays in releases
4. Time wasted debugging avoidable issues

## Objective
Create a reproducible, containerized testing workflow that:
1. Enforces consistent formatting (Black)
2. Runs static analysis (Ruff)
3. Is independent of local environments
4. Can be integrated directly into CI/CD pipelines

## Solution
I designed a Docker-based automated testing environment that:
1. Runs formatting checks with Black
2. Runs linting with Ruff
3. Ensures identical execution across machines
4. Can be executed locally or inside CI (GitHub Actions compatible)

## Architecture
```bash
Developer Code
      ↓
Docker Container
      ↓
Black (formatter)
Ruff (linter)
      ↓
Pass / Fail Exit Code
```

## How it works
You can find out all the command options by executing:
```bash
script/black_ruff_script.sh -h
```
Basic usage:
1. Build the container:
```bash
script/black_ruff_script.sh --black-version <black version> --ruff-version <ruff version> --mount-path <inside-container mount path of the code>
```
2. Execute the checks:
```bash
podman exec -it black_ruff_container black $mountPath
podman exec -it black_ruff_container ruff check $mountPath
```
3. You can also enter the container and execute the checks inside by using this command:
```bash
podman exec -it black_ruff_container sh
```
