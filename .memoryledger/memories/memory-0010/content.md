When working on package requests or fixes, you MUST install Nix from the official installer to properly test changes,
unless already present

```bash
sh <(curl -L https://nixos.org/nix/install) --daemon

echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

if [[ "$OSTYPE" == "darwin"* ]]; then
  sudo launchctl kickstart -k system/org.nixos.nix-daemon
else
  sudo systemctl restart nix-daemon
fi
```

### Common Issues and Solutions

1. **Rust packages with git dependencies**: May fail during cargo vendoring if dependencies have workspace inheritance issues. Consider using pre-built binaries as a workaround.

1. **Binary packages**: When packaging pre-built binaries:

   - Use `dontUnpack = true` if the download is a single executable file
   - Use `autoPatchelfHook` on Linux to handle dynamic library dependencies
   - Common missing libraries: `gcc-unwrapped.lib` for libgcc_s.so.1

1. **Update scripts**: Follow shellcheck recommendations - declare and assign variables separately to avoid masking return values.

1. **Custom nix-update arguments**: For packages that need special nix-update flags (e.g., filtering out nightly releases), create a `nix-update-args` file with one argument per line:

   ```text
   # packages/qwen-code/nix-update-args
   --use-github-releases
   --version-regex
   ^v([0-9]+\.[0-9]+\.[0-9]+)$
   ```

   The CI workflow reads this file and passes the arguments to nix-update automatically.
