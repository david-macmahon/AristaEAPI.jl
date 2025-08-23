module AristaEAPI

using Base64, Downloads, Random, JSON3

export run_command, run_commands, interfaces_counters_rates,
       interfaces_transceiver, lldp_neighbors, mac_address_table, isdynamic,
       isstatic

abstract type AbstractAristaEAPIStruct end

include("run_commands.jl")
include("interfaces_counters_rates.jl")
include("interfaces_transceiver.jl")
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

"""
    getas(::Type{T}, dict, key)::Union{T,Missing}

Get value for `key` from `dict` and parse as type `T`.  If `dict` does not
have `key` or if `dict[key]` cannot be parsed as type `T`, return `missing`.
`T` can be subtype of `Number` or `T` can be `String`.
"""
function getas(::Type{T}, dict, key)::Union{T,Missing} where T<:Number
    val = get(dict, key, missing)
    parseas(T, val)
end

function getas(::Type{String}, dict, key)::Union{String,Missing}
    haskey(dict, key) ? string(dict[key]) : missing
end

function parseas(::Type{T}, ::Missing)::Missing where T
    missing
end

function parseas(::Type{T}, x::T)::T where T
    x
end

function parseas(::Type{Tout}, x::Tin)::Tout where {Tout<:Number, Tin<:Number}
    Tout(x)
end

function parseas(::Type{Tout}, s::AbstractString)::Union{Tout,Missing} where {Tout<:Number}
    something(tryparse(Tout, s), missing)
end

function parseas(::Type{String}, x)
    something(string(x), missing)
end

end # module AristaEAPI
