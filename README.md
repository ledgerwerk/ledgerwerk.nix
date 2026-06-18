# holgern-pkgs.nix

<!-- BEGIN GENERATED PACKAGE DOCS -->

### Utilities

<details>
<summary><strong>archledger</strong> - Source-first arc42 architecture documentation from Markdown and AsciiDoc records</summary>

- **Source**: source
- **License**: Apache-2.0
- **Homepage**: https://github.com/holgern/archledger
- **Usage**: `nix run github:oduit/oduit.nix#archledger -- --help`
- **Nix**: [packages/archledger/package.nix](packages/archledger/package.nix)

</details>
<details>
<summary><strong>ledgercore</strong> - Shared core library for ledgerwerk tools</summary>

- **Source**: source
- **License**: Apache-2.0
- **Homepage**: https://github.com/ledgerwerk/ledgercore
- **Usage**: `nix run github:oduit/oduit.nix#ledgercore -- --help`
- **Nix**: [packages/ledgercore/package.nix](packages/ledgercore/package.nix)

</details>
<details>
<summary><strong>planledger</strong> - Durable project-state storage and CLI for coding workflows</summary>

- **Source**: source
- **License**: Apache-2.0
- **Homepage**: https://github.com/ledgerwerk/planledger
- **Usage**: `nix run github:oduit/oduit.nix#planledger -- --help`
- **Nix**: [packages/planledger/package.nix](packages/planledger/package.nix)

</details>
<details>
<summary><strong>releaseledger</strong> - Durable project-state storage and CLI for coding workflows</summary>

- **Source**: source
- **License**: Apache-2.0
- **Homepage**: https://github.com/holgern/taskledger
- **Usage**: `nix run github:oduit/oduit.nix#releaseledger -- --help`
- **Nix**: [packages/releaseledger/package.nix](packages/releaseledger/package.nix)

</details>
<details>
<summary><strong>taskledger</strong> - Durable project-state storage and CLI for coding workflows</summary>

- **Source**: source
- **License**: Apache-2.0
- **Homepage**: https://github.com/ledgerwerk/taskledger
- **Usage**: `nix run github:oduit/oduit.nix#taskledger -- --help`
- **Nix**: [packages/taskledger/package.nix](packages/taskledger/package.nix)

</details>
<details>
<summary><strong>wikimason</strong> - Filesystem-backed CLI toolkit for building and maintaining an LLM wiki</summary>

- **Source**: source
- **License**: MIT
- **Homepage**: https://github.com/ledgerwerk/wikimason
- **Usage**: `nix run github:oduit/oduit.nix#wikimason -- --help`
- **Nix**: [packages/wikimason/package.nix](packages/wikimason/package.nix)

</details>
<!-- END GENERATED PACKAGE DOCS -->

### Using Overlay

Alternatively, use an overlay to access packages under the `holgern-pkgs`
namespace. Two are provided:

- `overlays.default` exposes `packages.${system}` as-is. Packages are built
  against this flake's pinned nixpkgs, so the [binary cache](#binary-cache)
  hits regardless of your nixpkgs revision, at the cost of evaluating a second
  nixpkgs instance.
- `overlays.shared-nixpkgs` rebuilds each package against **your** nixpkgs, so
  dependencies are shared with the rest of your system and no extra nixpkgs is
  evaluated. The binary cache will only hit when your nixpkgs revision matches
  ours.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    holgern-pkgs.url = "github:holgern/holgern-pkgs.nix";
  };

  outputs = { nixpkgs, holgern-pkgs, ... }: {
    # NixOS / nix-darwin configuration
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [{
        nixpkgs.overlays = [ holgern-pkgs.overlays.default ];
        environment.systemPackages = [
          pkgs.holgern-pkgs.taskledger
          pkgs.holgern-pkgs.archledger
        ];
      }];
    };
  };
}
```

### Try Without Installing

Browse all available tools with the interactive launcher:

```bash
nix run github:holgern/holgern-pkgs.nix
```

This opens an fzf picker listing every package with its description.
Select one and it will be run via `nix run`.

Or run a specific tool directly:

```bash
nix run github:holgern/holgern-pgks.nix#taskledger
nix run github:holgern/holgern-pgks.nix#archledger
# etc...
```

## Development

### Setup Development Environment

```bash
nix develop
```

### Building Packages

```bash
# Build a specific package
nix build .#claude-code
nix build .#opencode
nix build .#qwen-code
# etc...
```

### Code Quality

```bash
# Format all code
nix fmt

# Run checks
nix flake check
```

## Package Details

### Platform Support

All packages support:

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `aarch64-darwin`

## Contributing

Contributions are welcome! Please:

1. Fork the repository
1. Create a feature branch
1. Run `nix fmt` before committing
1. Submit a pull request

## See also

- [natsukium/mcp-servers-nix](https://github.com/natsukium/mcp-servers-nix) - Nix packages for MCP (Model Context Protocol) servers
- [aaddrick/claude-desktop-debian](https://github.com/aaddrick/claude-desktop-debian?tab=readme-ov-file#using-nix-flake-nixos) - Claude Desktop for Linux
- [nothingnesses/agent-images](https://github.com/nothingnesses/agent-images) - Sandboxed OCI container images for AI coding agents

## License

Individual tools are licensed under their respective licenses.

The Nix packaging code in this repository is licensed under MIT.
