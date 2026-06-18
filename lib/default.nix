{ inputs, ... }:
inputs.nixpkgs.lib.extend (
  _final: prev: {
    maintainers = prev.maintainers // {
      holgern = {
        github = "holgern";
        name = "holgern";
      };
    };
  }
)
