{ lib }:

self: super: {
  haskell = super.haskell // {
    compiler = super.haskell.compiler // {
      ghc821 = super.haskell.compiler.ghc821.overrideAttrs (drv: {
        patches = (drv.patches or []) ++ lib.optionals (self.stdenv.targetPlatform.useAndroidPrebuilt or false) [
          ./8.2.y/android-patches/add-llvm-target-data-layout.patch
          ./8.2.y/android-patches/unix-posix_vdisable.patch
          ./8.2.y/android-patches/force_CC_SUPPORTS_TLS_equal_zero.patch
          ./8.2.y/android-patches/undefine_MYTASK_USE_TLV_for_CC_SUPPORTS_TLS_zero.patch
          ./8.2.y/android-patches/force-relocation-equal-pic.patch
          ./8.2.y/android-patches/rts_android_log_write.patch
        ] ++ lib.optionals (self.stdenv.targetPlatform != self.stdenv.hostPlatform) [
          ./8.2.y/android-patches/enable-fPIC.patch
        ] ++ lib.optionals (with self.stdenv.targetPlatform; (isDarwin && (isAarch64 || isArm))) [
          ./8.2.y/ios-rump-linker.patch
        ];
      });
    };
  };
}
