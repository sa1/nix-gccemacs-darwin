emacs-nativecomp: final: prev:
let
  emacsGccDarwin' = builtins.foldl' (drv: fn: fn drv)
    prev.emacs
    [

      (drv: drv.override { srcRepo = true; })

      (
        drv: drv.overrideAttrs (
          old: {
            name = "emacsGccDarwin";
            version = "28.0.50";
            src = emacs-nativecomp;

            configureFlags = old.configureFlags
              ++ [ "--with-cairo" "--with-harfbuzz" ];

            patches = [];

            postPatch = old.postPatch + ''
              substituteInPlace lisp/loadup.el \
              --replace '(emacs-repository-get-version)' '"${emacs-nativecomp.rev}"' \
              --replace '(emacs-repository-get-branch)' '"master"'
            '';

            postInstall = old.postInstall + ''
                ln -snf $out/lib/emacs/28.0.50/native-lisp $out/Applications/Emacs.app/Contents/native-lisp
            '';
          }
        )
      )
      (
        drv: drv.override {
          nativeComp = true;
        }
      )
    ];
  emacsPackages = prev.emacsPackagesFor emacsGccDarwin';
  emacsWithPackages = emacsPackages.emacsWithPackages;
  emacsGccDarwin = emacsWithPackages (e: [ e.pdf-tools e.vterm ]);

in
{
  inherit emacsGccDarwin;
}
