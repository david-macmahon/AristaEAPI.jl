# AristaEAPI.jl

*[Arista EAPI][] client for [Julia][]*

[Arista EAPI]: https://www.arista.com/assets/data/pdf/Whitepapers/Arista_eAPI_FINAL.pdf
[Julia]: https://julialang.org/

[![docs-stable badge](https://img.shields.io/badge/docs-stable-blue.svg)](https://david-macmahon.github.io/AristaEAPI.jl/stable)
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
These function return the results as a `Vector` of structures.  Each functions
has a corresponding structure defined for it.  The returned `Vector`s are
compatible with `Tables.jl`, so they can be used with any `Table.jl` comsumer,
such as [`PrettyTables.jl`][].  When used with `PrettyPrint`, `pretty_table`
methods are defined to alter some default keyword argument values to display all
entries and provide more tailored alignment (as shown in the example below).

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

#### Example

```julia-repl
julia> interfaces_counters_rates("myswitch", "et4/1-et5/4")|>pretty_table
┌─────────────┬─────────────┬──────────┬────────────────┬──────────────┬──────────────┬─────────┬─────────────┬──────────┐
│ port        │ description │ interval │         in_bps │      in_util │       in_pps │ out_bps │    out_util │  out_pps │
├─────────────┼─────────────┼──────────┼────────────────┼──────────────┼──────────────┼─────────┼─────────────┼──────────┤
│ Ethernet4/1 │             │      300 │    9.10519e9   │ 91.4426      │  2.44134e5   │ 21967.1 │ 0.000232733 │  8.16335 │
│ Ethernet4/2 │             │      300 │    9.1052e9    │ 91.4426      │  2.44134e5   │ 21947.4 │ 0.000232518 │  8.1528  │
│ Ethernet4/3 │             │      300 │    9.10519e9   │ 91.4426      │  2.44134e5   │ 21944.4 │ 0.000232479 │  8.14663 │
│ Ethernet4/4 │             │      300 │    9.1052e9    │ 91.4426      │  2.44134e5   │ 21944.6 │ 0.000232483 │  8.1481  │
│ Ethernet5/1 │             │      300 │    5.03642e-17 │  5.31133e-25 │  1.71821e-20 │ 21686.8 │ 0.000229122 │  7.65873 │
│ Ethernet5/2 │             │      300 │    9.1052e9    │ 91.4426      │  2.44134e5   │ 21955.6 │ 0.000232627 │  8.16933 │
│ Ethernet5/3 │             │      300 │ 5682.48        │  7.307e-5    │ 10.1532      │ 32662.7 │ 0.000370916 │ 27.6806  │
│ Ethernet5/4 │             │      300 │    9.1052e9    │ 91.4426      │  2.44134e5   │ 21943.1 │ 0.000232465 │  8.14637 │
└─────────────┴─────────────┴──────────┴────────────────┴──────────────┴──────────────┴─────────┴─────────────┴──────────┘
```

### Low level

This package provides two low level but flexible functions that can be used to
run any commands that your switch supports via the Arista EAPI.

```julia
    run_command(host, cmd::AbstractString; username, password, protocol)
```

```julia
    run_commands(host, cmds::AbstractVector; username, password, protocol)
```
