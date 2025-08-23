module AristaEAPI

using Base64, Downloads, Random, JSON3

export run_command, run_commands, interfaces_counters_rates, lldp_neighbors,
       mac_address_table

include("run_commands.jl")
include("interfaces_counters_rates.jl")
include("lldp_neighbors.jl")
include("mac_address_table.jl")

"""
    numbered(s) -> (str,int)

Return `Tuple` of the `String` prefix and `Int` suffix of `s`.

If `s` does not have a numeric suffix, then the `Int` component will be
`typemin(Int)`.  This function is intended for use as a `by` function for
`sort`.  `s` may be an `AbstractString` or a `Symbol`.
"""
function numbered(s::AbstractString)
    m = match(r"(\D+)(\d+)", s)
    isnothing(m) ? (s,typemin(Int)) : (m[1], parse(Int, m[2]))
end

numbered(s::Symbol) = numbered(string(s))

split_numbered(s::AbstractString, delim="/") = numbered.(Tuple(split(s, delim)))
split_numbered(s::Symbol, delim="/") = numbered.(Tuple(split(string(s), delim)))

end # module AristaEAPI
