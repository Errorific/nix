# Installation

1. Get machine all partitioned up ready to go with a nixos livecd
2. Create /etc/nixos/configuration.nix with contents where machineName is the name of the machine (errorbook is the only one this repo knows about)
```nix
let thunk = builtins.fromJSON (builtins.readFile /etc/nixos/thunk.json);
in (import (builtins.fetchGit {
  inherit (thunk) url rev;
})) "{{machineName}}"
```
3. Run the contents of (update.sh)[./update.sh] to create a current thunk.json
4. Proceed with nixos installation, or do a `nixos-rebuild switch` if the machine is already installed