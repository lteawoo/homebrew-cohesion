class Cohesion < Formula
  desc "Self-hosted file service for browsing and sharing files"
  homepage "https://github.com/lteawoo/Cohesion"
  version "0.7.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.7.0/cohesion_0.7.0_apple_darwin_arm64.tar.gz"
      sha256 "05eeed014a156dcc9c71c7a01ca2bb438687e65f9bd291e72e6ddeb9926b442c"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.7.0/cohesion_0.7.0_apple_darwin_amd64.tar.gz"
      sha256 "d9845a434d619e91d90e76b6c12c68c8a4b35aa4e00c9b6c0f621bdf484d832b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.7.0/cohesion_0.7.0_linux_arm64.tar.gz"
      sha256 "9128c8c03ee292a4b69f5cfd7f5edff83b0bb7f1e0433ace6bf86e037d057811"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.7.0/cohesion_0.7.0_linux_amd64.tar.gz"
      sha256 "fa402b7517daf99d43d64c0a44096fa893b4639398eb97eb5abe644eb2c642ee"
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
