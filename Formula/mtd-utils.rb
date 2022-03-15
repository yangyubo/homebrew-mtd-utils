# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class MtdUtils < Formula
  desc "User space tools to work with MTD kernel subsystem."
  homepage ""
  url "https://github.com/yangyubo/mtd-utils/releases/download/2.1.1-macOS/mtd-utils-2.1.1.tar.bz2"
  sha256 "7541d7bbe24825266140dab11269753cdf520d67b39194f95e4c646287149e72"
  license "GPL-2.0"

  depends_on "lzo"

  def install
    if OS.mac?
      ENV.append "CFLAGS", "-Dloff_t=off_t -D__BYTE_ORDER=BYTE_ORDER -include machine/endian.h -DNO_NATIVE_SUPPORT -include include/fls.h"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-tests
      --without-crypto
      --without-xattr
      --without-zstd
    ]

    system "./configure", *args
    system "make", "ubinize", "mkfs.ubifs"
    ENV.deparallelize
    sbin.install "ubinize"
    sbin.install "mkfs.ubifs"
  end

  test do
    assert_match "ubinize (mtd-utils)", shell_output("#{bin}/ubinize -V 2>&1")
  end
end
