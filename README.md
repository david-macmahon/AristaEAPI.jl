# AristaEAPI.jl

*[Arista EAPI][] client for [Julia][]*

[Arista EAPI]: https://www.arista.com/assets/data/pdf/Whitepapers/Arista_eAPI_FINAL.pdf
[Julia]: https://julialang.org/

[![docs-dev badge](https://img.shields.io/badge/docs-dev-blue.svg)](https://david-macmahon.github.io/AristaEAPI.jl/dev)

## Overview

`AristaEAPI.jl` provides a Julia client for running commands on Arista switches
using the *Arista Command API*, aka the *Arista EAPI*.  The Arista EAPI can be
enabled on supported switches by running these commands on the switch:

```plaintext
myswitch> enable
myswitch# configure terminal
myswitch(config)# management api http-commands
myswitch(config-mgmt-api-http-cmds)# protocol https
myswitch(config-mgmt-api-http-cmds)# no shutdown
```

## Installation

This package is not in the `General` registry yet, so you must add it by URL:

### Using the `pkg>` mode

Press `]` at the start of a line in the Julia REPL to enter `pkg>` mode:

```julia-repl
pkg> add https://github.com/david-macmahon/AristaEAPI.jl
```

### Using `Pkg` from the command line

```bash
julia -e 'import Pkg; Pkg.add(url="https://github.com/david-macmahon/AristaEAPI.jl")'
```

## Usage

Here is a quick summary of the low level and high level functions.  See
[the documentation][] for more detailed information.

[the documentation]: https://david-macmahon.github.io/AristaEAPI.jl/dev

### High level

This package provides high level functions for some commonly used commands.
These function return the results in a more concise format (i.e. as a
`Vector{NamedTuple}`).

```julia
    interfaces_counters_rates(host, interfaces=""; username, password, protocol)
```

```julia
    lldp_neighbors(host, interfaces=""; username, password, protocol)
```

```julia
    mac_address_table(host, interfaces=""; address="", username, password, protocol)
```

Hint: [`PrettyTables.jl`] can print a `Vector{NamedTuple}` as a pretty table.

[`PrettyTables.jl`]: https://ronisbr.github.io/PrettyTables.jl/stable/

### Low level

This package provides two low level but flexible functions that can be used to
run any commands that your switch supports via the Arista EAPI.

```julia
    run_command(host, cmd::AbstractString; username, password, protocol)
```

```julia
    run_commands(host, cmds::AbstractVector; username, password, protocol)
```
