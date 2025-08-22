# AristaEAPI.jl Documentation

```@contents
```

## High level functions

These functions return the results of commonly used commands for getting switch
status and statistics.  All of them return a `Vector{NamedTuple}`.  The keys of
the `NamedTuple`s closely follow the field names used in the textual output of
the switch CLI.

```@docs
interfaces_counters_rates
lldp_neighbors
mac_address_table
```

## Low level function

This function is used by the high level functions to run commands on the switch
using the Arista EAPI.  It can be used to run any commands that your switch
supports over EAPI.

```@docs
run_commands
```

## Index

```@index
```
