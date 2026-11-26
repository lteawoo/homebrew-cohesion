class Cohesion < Formula
  desc "Self-hosted file service for browsing and sharing files"
  homepage "https://github.com/lteawoo/Cohesion"
  version "0.9.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.9.0/cohesion_0.9.0_apple_darwin_arm64.tar.gz"
      sha256 "9f8e5f8060954c16cf08528e55e2d1862b9360d52c9e7d3cf9a9d41b6a21822e"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.9.0/cohesion_0.9.0_apple_darwin_amd64.tar.gz"
      sha256 "88eb5756a8f9ba9be230c02c5e5b6c278b8eea8553b5b8cee83488b96c59c829"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.9.0/cohesion_0.9.0_linux_arm64.tar.gz"
      sha256 "22164ac930ed102460c7a51c7359789a17ec4379e87022e69068216b5442dc7b"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.9.0/cohesion_0.9.0_linux_amd64.tar.gz"
      sha256 "a008ecfb3982cf63fe0e7a84a812fbaf69d2ee85b94d7ac4ace660101330ad3c"
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
