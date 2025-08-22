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

Thes functions are used by the high level functions to run commands on the
switch using the Arista EAPI.  They can be used to run any commands that your
switch supports over EAPI.  This function returns a `JSON3.Object` that can be
used as a `Dict{Symbol, Any}`.  This object represents the JSON RPC response
from the switch.  The results of interest can be obtained from this object via
the `:result` key.

```@docs
run_command
run_commands
```

### Example

```julia-repl
julia> reply = run_command("arista1g", "show version")
JSON3.Object{Base.CodeUnits{UInt8, String}, Vector{UInt64}} with 3 entries:
  :jsonrpc => "2.0"
  :result  => Object[{…
  :id      => "AristaEAPI.jl-yA6T96mC"

julia> reply[:result]
1-element JSON3.Array{JSON3.Object, Base.CodeUnits{UInt8, String}, SubArray{UInt64, 1, Vector{UInt64}, Tuple{UnitRange{Int64}}, true}}:
 {
          "modelName": "DCS-7048T-A-R",
    "internalVersion": "4.15.7M-3284043.4157M",
   "systemMacAddress": "00:1c:73:a0:b8:df",
       "serialNumber": "JPE14471431",
           "memTotal": 3978148,
    "bootupTimestamp": 1.75581673972e9,
            "memFree": 770812,
            "version": "4.15.7M",
       "architecture": "i386",
      "isIntlVersion": false,
    "internalBuildId": "b0b0dff8-c9ca-40cc-a625-7fd3c8c76ebd",
   "hardwareRevision": "01.07"
}
```

## Index

```@index
```
