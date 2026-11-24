class Cohesion < Formula
  desc "Self-hosted file service for browsing and sharing files"
  homepage "https://github.com/lteawoo/Cohesion"
  version "0.6.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.6.0/cohesion_0.6.0_apple_darwin_arm64.tar.gz"
      sha256 "99c950bb5566a79e925ef96b9e74a8de62afb8c99e2693b6c27f09040144110d"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.6.0/cohesion_0.6.0_apple_darwin_amd64.tar.gz"
      sha256 "ed067e8e636eafae4fd78abc28f9866658fd0e362bc4ef56ac96319beb30fdc6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.6.0/cohesion_0.6.0_linux_arm64.tar.gz"
      sha256 "52f2a7bfe474475560fb1f36a11e9de0c218ed12a4aafed021c4715a203e3d3f"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.6.0/cohesion_0.6.0_linux_amd64.tar.gz"
      sha256 "778fce158a6efbf33b64ef618029d1f37a92c5248b8aa5ee2e14bc7014e213f5"
    end
  end

  def install
    bin.install "cohesion"
    bin.install "cohesion-updater"
    pkgshare.install "README.md"
    pkgshare.install "config/config.prod.yaml"
  end

  def post_install
    runtime_dir = var/"cohesion/runtime"

    (runtime_dir/"data").mkpath
    (runtime_dir/"logs").mkpath
  end

  service do
    run [opt_bin/"cohesion"]
    environment_variables COHESION_RUNTIME_ROOT: (var/"cohesion/runtime").to_s
    working_dir (var/"cohesion").to_s
    keep_alive true
    log_path var/"log/cohesion.log"
    error_log_path var/"log/cohesion.error.log"
  end

  def caveats
    <<~EOS
      Cohesion config path:
        ~/.cohesion/config/config.prod.yaml

      Cohesion data path:
        ~/.cohesion/data/cohesion.db

      Cohesion secrets path:
        ~/.cohesion/secrets/

      Start the service:
        brew services start cohesion

      Stop the service:
        brew services stop cohesion

      Update the package:
        brew upgrade cohesion

      In-app self-update is disabled for Homebrew installs.
    EOS
  end

  test do
    assert_predicate bin/"cohesion", :exist?
    assert_predicate bin/"cohesion-updater", :exist?
    assert_predicate pkgshare/"config.prod.yaml", :exist?
  end
end
