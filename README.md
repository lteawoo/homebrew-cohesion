# Homebrew Tap Bootstrap

This directory keeps the Cohesion Homebrew formula source before it is published to a dedicated tap repository.

## Current Target

- Tap repository name: `lteawoo/homebrew-tap`
- Install command: `brew install lteawoo/tap/cohesion`
- Update command: `brew upgrade cohesion`

## Files

- `Formula/cohesion.rb`: formula ready to copy into the tap repository

## Refresh Formula

Render the formula from the latest GitHub release metadata:

```bash
pnpm release:homebrew-formula
```

Render a specific tag:

```bash
pnpm release:homebrew-formula -- --tag v0.5.17
```

## Publish Checklist

1. Create the `homebrew-tap` repository.
2. Copy `Formula/cohesion.rb` into `homebrew-tap/Formula/cohesion.rb`.
3. Add a tap README with install and service instructions.
4. Verify:
   - `brew install lteawoo/tap/cohesion`
   - `brew services start cohesion`
   - `brew upgrade cohesion`
