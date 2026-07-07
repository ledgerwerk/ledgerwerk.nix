Preserved repository guidance from the pre-memoryledger AGENTS.md:

Project structure: root contains flake.nix, flake.lock, devshell.nix, README.md. Packages live under packages/<tool>/ with package.nix, default.nix, optional update.py, and lockfiles when needed. Formatting config is packages/formatter/treefmt.nix. Utilities and docs live in scripts/, docs/, and .github/.

Build and development commands: enter the dev shell with nix develop. Build a package with nix build --accept-flake-config .#<package>. Run a package without installing with nix run .#<package> -- --help. Run repository checks with nix flake check. Format everything with nix fmt. Regenerate the README package section with ./scripts/generate-package-docs.py.

Testing guidelines: build locally with nix build .#<package>. Run flake checks with nix flake check. Per-package checks can be built with nix build .#checks.$(nix eval --raw --impure --expr builtins.currentSystem).pkgs-<package>. For scripts, ensure shellcheck passes, and enable doCheck = true in packages when feasible.

Commit and pull request guidelines: commit style mirrors history: <package>: summary. Version bumps use <package>: X -> Y (#123). New packages use <package>: init at X.Y.Z. PRs should include a clear description, rationale, testing notes, linked issues, and sample run output for CLIs. Before pushing, run nix fmt and nix flake check.

Security and configuration tips: some tools are unfree, so enable unfree if needed in Nix config. Sandbox experiments are documented in packages/claudebox/. Pin sources with hashes and avoid network access at build time.
