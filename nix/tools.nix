{ stdenv
, lib

, actionlint
, alejandra
, ansible-lint
, biome
, cabal-fmt
, cabal-gild
, cabal2nix
, callPackage
, cargo
, checkmake
, circleci-cli
, llvmPackages_latest
, clippy
, cljfmt
, cmake-format
, commitizen
, conform
, convco
, crystal
, dart
, deadnix
, deno
, dhall
, dune_3
, eclint
, editorconfig-checker
, elixir
, elmPackages
, flake-checker ? null
, fprettify
, git-annex
, gitlint
, gptcommit ? null
, hadolint
, haskellPackages
, hindent
, hlint
, hpack
, html-tidy
, luaPackages
, lua-language-server
, lychee
, julia-bin
, mdformat
, mdl
, mdsh
, nil
, nixfmt
, nixfmt-classic ? null
, nixfmt-rfc-style ? null
, nixpkgs-fmt
, nodePackages
, ocamlPackages
, opam
, opentofu
, ormolu
, pkgsBuildBuild
, poetry
, pre-commit-hook-ensure-sops ? null
, proselint
, python3Packages
, pyright ? nodePackages.pyright
, php82Packages
, ripsecrets ? null
, reuse
, ruff ? null
, rustfmt
, selene
, shellcheck
, bats
, shfmt
, beautysh
, statix
, stylish-haskell
, stylua
, tagref
, taplo
, texlive
, topiary ? null ## Added in nixpkgs on Dec 2, 2022
, treefmt
, trufflehog
, typos
, typstfmt
, typstyle ? null ## Add in nixpkgs added on commit 800ca60
, zprint
, yamlfmt
, yamllint
, go
, go-tools
, golangci-lint
, golines
, revive ? null
, uv
, vale
}:


let
  tex = texlive.combine {
    inherit (texlive) latexindent chktex scheme-basic;
  };
in
{
  clang-tools = llvmPackages_latest.clang-tools;
  inherit
    actionlint
    alejandra
    ansible-lint
    beautysh
    biome
    cabal2nix
    cabal-fmt
    cabal-gild
    cargo
    circleci-cli
    clippy
    cljfmt
    cmake-format
    conform
    convco
    crystal
    dart
    deadnix
    deno
    dhall
    eclint
    editorconfig-checker
    elixir
    flake-checker
    fprettify
    gitlint
    go
    go-tools
    golangci-lint
    golines
    gptcommit
    hadolint
    hindent
    hlint
    hpack
    html-tidy
    lychee
    mdformat
    mdl
    mdsh
    nil
    nixpkgs-fmt
    opentofu
    ormolu
    pre-commit-hook-ensure-sops
    poetry
    proselint
    pyright
    reuse
    revive
    ripsecrets
    ruff
    rustfmt
    selene
    shellcheck
    shfmt
    statix
    stylish-haskell
    stylua
    tagref
    taplo
    topiary
    treefmt
    trufflehog
    typos
    typstfmt
    typstyle
    uv
    vale
    yamlfmt
    yamllint
    zprint
    ;
  inherit (elmPackages) elm-format elm-review elm-test;
  # TODO: these two should be statically compiled
  inherit (haskellPackages) fourmolu;
  inherit (luaPackages) luacheck;
  inherit (nodePackages) eslint markdownlint-cli prettier cspell;
  inherit (ocamlPackages) ocp-indent;
  inherit (python3Packages) autoflake black flake8 flynt isort mkdocs-linkcheck mypy openapi-spec-validator pre-commit-hooks pylint pyupgrade;
  inherit (php82Packages) php-cs-fixer psalm;
  # FIXME: workaround build failure
  phpstan = php82Packages.phpstan.overrideAttrs (old: {
    composerStrictValidation = false;
  });
  # these two are for backwards compatibility
  phpcbf = php82Packages.php-codesniffer or php82Packages.phpcbf;
  phpcs = php82Packages.php-codesniffer or php82Packages.phpcs;
  lua-language-server = lua-language-server;
  purs-tidy = nodePackages.purs-tidy or null;
  cabal2nix-dir = callPackage ./cabal2nix-dir { };
  hpack-dir = callPackage ./hpack-dir { };
  hunspell = callPackage ./hunspell { };
  purty = callPackage ./purty { purty = nodePackages.purty; };
  terraform-validate = callPackage ./terraform-validate { };
  tflint = callPackage ./tflint { };
  dune-build-opam-files = callPackage ./dune-build-opam-files { dune = dune_3; inherit (pkgsBuildBuild) ocaml; };
  dune-fmt = callPackage ./dune-fmt { dune = dune_3; inherit (pkgsBuildBuild) ocaml; };
  latexindent = tex;
  lacheck = texlive.combine {
    inherit (texlive) lacheck scheme-basic;
  };
  chktex = tex;
  commitizen = commitizen.overrideAttrs (_: _: { doCheck = false; });
  bats = if bats ? withLibraries then (bats.withLibraries (p: [ p.bats-support p.bats-assert p.bats-file ])) else bats;
  git-annex = if stdenv.isDarwin then null else git-annex;
  # Note: Only broken in stable nixpkgs, works fine on latest master.
  opam = if stdenv.isDarwin then null else opam;

  ## NOTE: `checkmake` 0.2.2 landed in nixpkgs on 12 April 2023. Once this gets
  ## into a NixOS release, the following code will be useless.
  checkmake = if stdenv.isLinux || checkmake.version >= "0.2.2" then checkmake else null;

  headache = callPackage ./headache { };

  # Disable tests as these take way to long on our infra.
  julia-bin = julia-bin.overrideAttrs (_: _: { doInstallCheck = false; });

  # nixfmt was renamed to nixfmt-classic in 24.05.
  # nixfmt may be replaced by nixfmt-rfc-style in the future.
  nixfmt = if nixfmt-classic == null then nixfmt else nixfmt-classic;
  inherit nixfmt-classic nixfmt-rfc-style;
}
