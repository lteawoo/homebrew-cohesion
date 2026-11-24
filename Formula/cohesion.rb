class Cohesion < Formula
  desc "Self-hosted file service for browsing and sharing files"
  homepage "https://github.com/lteawoo/Cohesion"
  version "0.5.22"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.5.22/cohesion_0.5.22_apple_darwin_arm64.tar.gz"
      sha256 "3bfc12010534d24641c1dc7522387617d2f11f3203346fd7145bbfa6b5091dca"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.5.22/cohesion_0.5.22_apple_darwin_amd64.tar.gz"
      sha256 "8826134d3e0ff142252a54e9c68fa92fd799eb565d365d7b092911acb658c690"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.5.22/cohesion_0.5.22_linux_arm64.tar.gz"
      sha256 "5d7723bacb57f1c71d910338657dd6049109441488b17552833a5fbca7e7f89f"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.5.22/cohesion_0.5.22_linux_amd64.tar.gz"
      sha256 "3bc6b9aa547768fe94239c78992cae64b95880cfe91f99c7dfec749f4aac7113"
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
