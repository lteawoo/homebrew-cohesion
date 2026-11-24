# Cohesion Homebrew tap

Install Cohesion on macOS or Linux and start its background service.

```bash
brew install lteawoo/cohesion/cohesion
brew services start cohesion
```

Open `http://localhost:3000` to finish setup.

## Update

```bash
brew update
brew upgrade cohesion
brew services restart cohesion
```

## Maintain the formula

From a checkout of the Cohesion application, run the following command with the release tag and the path to this tap.

```bash
pnpm release:homebrew-formula --tag <release-tag> --output /path/to/homebrew-cohesion/Formula/cohesion.rb
```

Verify the macOS and Linux archive checksums against the release before merging the formula update. [Cohesion releases](https://github.com/lteawoo/Cohesion/releases)
