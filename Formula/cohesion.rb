class Cohesion < Formula
  desc "Self-hosted file service for browsing and sharing files"
  homepage "https://github.com/lteawoo/Cohesion"
  version "0.8.0"
  license "AGPL-3.0-only"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.8.0/cohesion_0.8.0_apple_darwin_arm64.tar.gz"
      sha256 "ce0c04346f166190f2de94ba5325d7abad59c9635b72556734a007cd72575243"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.8.0/cohesion_0.8.0_apple_darwin_amd64.tar.gz"
      sha256 "ab68c3b19989f2ad6c497e90ccc96456a99c73818f3d7cd6720e931bc9dd0133"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.8.0/cohesion_0.8.0_linux_arm64.tar.gz"
      sha256 "8850196a921d3e02bb0369d8e2fe3b85268937d7ecb9af37658892604c4eb732"
    else
      url "https://github.com/lteawoo/Cohesion/releases/download/v0.8.0/cohesion_0.8.0_linux_amd64.tar.gz"
      sha256 "5d86b46a23e4260fd088ccd895d85a265fe740910b55dfd02510aeb15f1abad3"
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
