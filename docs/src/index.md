# AristaEAPI.jl Documentation

```@contents
```

## High level interface

The high level interface consists of functions and structures that make it easy
and convenient to query the switch for statistics and status information and
work with the returned data.

### Functions

The high level interface provides query functions and predicate functions.
Query functions communicate with the switch to get statistics and status
information.  Predicate functions can be used with functions that take a
predicate function, such as `filter`, `findall`, etc.

#### Query functions

These function return the results as a `Vector` of structures.  Each functions
has a corresponding structure defined for it.  The returned `Vector`s are
compatible with `Tables.jl`, so they can be used with any `Table.jl` consumer,
such as [`PrettyTables.jl`](https://ronisbr.github.io/PrettyTables.jl/stable/)
When used with `PrettyTables`, `pretty_table` methods are defined to alter some
default keyword argument values to display all entries and provide more tailored
alignment (as shown in the example below).

```@docs
interfaces_counters_rates
interfaces_transceiver
lldp_neighbors
mac_address_table
```

##### Example

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

#### Predicate functions

These predicate functions are intended for use with `filter`, `findall`, etc.

```@docs
isdynamic
isstatic
```

### Structures

The structures defined by `AristaEAPI.jl` are documented here.

```@docs
AristaEAPI.InterfacesCountersRates
AristaEAPI.InterfacesTransceiver
AristaEAPI.LLDPNeighbors
AristaEAPI.MACAddressRecord
```

## Low level interface

These functions are used by the high level functions to run commands on the
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
