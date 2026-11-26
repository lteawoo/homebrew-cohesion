class Cohesion < Formula
  desc "Self-hosted file service for browsing and sharing files"
  homepage "https://github.com/lteawoo/Cohesion"
  version "0.8.1"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.8.1/cohesion_0.8.1_apple_darwin_arm64.tar.gz"
      sha256 "7a7de0965aa26c472fbb4a9cfee9d2cb4a745d9228c9db709bd7867c9c3e73d0"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.8.1/cohesion_0.8.1_apple_darwin_amd64.tar.gz"
      sha256 "3cc46e9d2359c87e2293e75dd5beeaddf6fc19318a13eabf7e917d3ac1a4b3e0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.8.1/cohesion_0.8.1_linux_arm64.tar.gz"
      sha256 "c8c70aff133bec49c00dbfff520e956ad875d61592b205bd44de178c853d1af3"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.8.1/cohesion_0.8.1_linux_amd64.tar.gz"
      sha256 "03172b52da332b0d0fa9f4c2116dc9bd276aa694c745c3cb29f54412935d1911"
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
