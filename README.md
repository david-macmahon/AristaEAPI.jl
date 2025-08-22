# AristaEAPI.jl
*[Arista EAPI][] client for [Julia][]*

[Arista EAPI]: https://www.arista.com/assets/data/pdf/Whitepapers/Arista_eAPI_FINAL.pdf
[Julia]: https://julialang.org/

[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://david-macmahon.github.io/AristaEAPI.jl/dev)

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

Using `pkg>` mode of the Julia REPL:

```julia
pkg> add https://github.com/david-macmahon/AristaEAPI.jl
```

Using `Pkg` from the command line:

```bash
$ julia -e 'import Pkg; Pkg.add(url="https://github.com/david-macmahon/AristaEAPI.jl")'
```

## Usage

Here is a quick summary of the low level and high level functions.  See
[the documentation][] for more detailed information.

[the documentation]: https://david-macmahon.github.io/AristaEAPI.jl/dev

### Low level

This package provides a low level but flexible `run_commands` function which can
be used to run any commands that your switch supports vis the Arista EAPI.  This
call returns a `JSON3.Object` that can be used as a `Dict{Symbol, Any}`.  This
object represents the JSON RPC response from the switch.  The results of
interest will be in `d[:result]` (you can also use `d.result`).

```julia
    run_commands(host, cmds::AbstractVector; username, password, protocol)
```

### High level

This package provides some functions for some commonly used commands.  These
high level function return the results in a more concise format (i.e. as a
`Vector` of `NamedTuples`).

[`PrettyTables.jl`]: https://ronisbr.github.io/PrettyTables.jl/stable/

```julia
    interfaces_counters_rates(host, interfaces=""; username, password, protocol)
```

```julia
    lldp_neighbors(host, interfaces=""; username, password, protocol)
```

```julia
    mac_address_table(host, interfaces=""; address="", username, password, protocol)
```

Hint: [`PrettyTables.jl`] can print a `Vector` of `NamedTuples` as a pretty
table.
