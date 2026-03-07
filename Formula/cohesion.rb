class Cohesion < Formula
  desc "Self-hosted file service for browsing and sharing files"
  homepage "https://github.com/lteawoo/Cohesion"
  version "0.5.19"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.5.19/cohesion_0.5.19_apple_darwin_arm64.tar.gz"
      sha256 "9450f87ac612dc58c220a3afc85b5c63fdca63622acce6b16dec96ecc7dff480"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.5.19/cohesion_0.5.19_apple_darwin_amd64.tar.gz"
      sha256 "8a88777d6236c1c3f152f08e3db039e5650af92d488e78c2acbb5b40d7cae784"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.5.19/cohesion_0.5.19_linux_arm64.tar.gz"
      sha256 "5668726c42876d1a33cccee1d0f3396f3904f034cb619fbd4a00df239ab5052d"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.5.19/cohesion_0.5.19_linux_amd64.tar.gz"
      sha256 "91fe88ab4215bc18aafd7fbf5048cd885174e6ccbb01778f778188a3c454e28f"
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
