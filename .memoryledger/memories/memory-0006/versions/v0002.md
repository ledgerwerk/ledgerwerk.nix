- Indentation: 2 spaces; avoid tabs.
- Nix: small, composable derivations; prefer `buildNpmPackage`/`rustPlatform.buildRustPackage`/`stdenv.mkDerivation` as in existing packages.
- File layout per package: `package.nix` (definition), `default.nix` (wrapper), `update.py` (optional custom updater), `nix-update-args` (optional nix-update flags).
- Tools via treefmt: nixfmt, deadnix, shfmt, shellcheck, mdformat, yamlfmt, taplo. Always run `nix fmt` before committing.

### Updating Packages

**Prefer `nix-update` over custom update scripts.** Most packages can be updated with:

```bash
nix run nixpkgs#nix-update -- --flake <package>
```

For this to work, `package.nix` must have version/hash attributes inline (not loaded from JSON):

```nix
buildGoModule rec {
  pname = "example";
  version = "1.0.0";  # nix-update finds and updates this

  src = fetchFromGitHub {
    owner = "owner";
    repo = "repo";
    rev = "v${version}";
    hash = "sha256-...";  # nix-update updates this
  };

  subPackages = [ "." ];  # for go find the relevant packages containing the binary

  vendorHash = "sha256-...";  # nix-update updates this too
}
```

**Testing updates**: After writing or modifying a package, verify updates work by:

1. Temporarily downgrading the version in `package.nix`
1. Running `nix run nixpkgs#nix-update -- --flake <package>`
1. Confirming version and hashes are updated correctly

**Only use custom `update.py` scripts when nix-update cannot handle the package**, such as:

- Packages with complex version schemes nix-update cannot parse
- Sources not supported by nix-update (non-GitHub, custom APIs)
- Packages requiring special hash calculation logic

Custom updaters should use the `scripts/updater/` library. See existing `update.py` files for examples.

### Package Metadata Requirements

Every package MUST have proper metadata in `package.nix`:

```nix
meta = with lib; {
  description = "Clear, concise description";
  homepage = "https://project-homepage.com";
  changelog = "https://github.com/owner/repo/releases/tag/v${version}";
  license = licenses.mit; # or licenses.unfree, etc.
  sourceProvenance = with lib.sourceTypes; [ fromSource ];
  maintainers = with maintainers; [ username ];
  mainProgram = "binary-name";
  platforms = platforms.all; # or specific platforms
};
```

The `changelog` attribute is **required** — our updater uses it to generate release notes. Use a version-specific URL matching the upstream tag format (e.g. `v${version}`, `${version}`, `rust-v${version}`). Fall back to `/releases` when tags are inconsistent. Verify the URL doesn't 404.

### Package Categories

Every package should have a category in `passthru` for README organization:

```nix
passthru.category = "AI Coding Agents";

meta = { ... };
```

Available categories (in display order):

- **Testing** - 
- **Packaging** - ()
- **Utilities** - Other useful tools

#### Custom Maintainers

For maintainers not yet in nixpkgs, define them in `lib/default.nix`:

```nix
{ inputs, ... }:
inputs.nixpkgs.lib.extend (
  _final: prev: {
    maintainers = prev.maintainers // {
      username = {
        github = "github-username";
        githubId = 123456; # Get from: curl -s https://api.github.com/users/username | jq -r '.id'
        name = "Full Name";
      };
    };
  }
)
```

Then in `packages/<package>/default.nix`, pass `flake` to the package:

```nix
{ pkgs, flake }: pkgs.callPackage ./package.nix { inherit flake; }
```

And in `packages/<package>/package.nix`, reference custom maintainers:

```nix
{
  lib,
  flake,
  # ... other args
}:

stdenv.mkDerivation rec {
  # ...
  meta = with lib; {
    maintainers = with flake.lib.maintainers; [ username ];
    # ... other meta
  };
}
```

### Version Check Hooks

Use `versionCheckHook` to verify packages report correct versions during build:

```nix
doInstallCheck = true;
nativeInstallCheckInputs = [ versionCheckHook ];
```

**For tools that need a writable HOME directory** (many CLI tools try to create config/cache directories), use `versionCheckHomeHook`:

1. In `packages/<package>/default.nix`, pass the hook:

   ```nix
   {
     pkgs,
     perSystem,
     ...
   }:
   pkgs.callPackage ./package.nix {
     inherit (perSystem.self) versionCheckHomeHook;
   }
   ```

1. In `packages/<package>/package.nix`, add it to inputs and use it:

   ```nix
   {
     versionCheckHook,
     versionCheckHomeHook,
     # ...
   }:
   stdenv.mkDerivation {
     # ...
     doInstallCheck = true;
     nativeInstallCheckInputs = [
       versionCheckHook
       versionCheckHomeHook
     ];
   }
   ```
