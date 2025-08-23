"""
    struct InterfacesCountersRates <: AbstractAristaEAPIStruct
        port::String
        description::Union{String, Missing}
        interval::Union{Int, Missing}
        in_bps::Union{Float64, Missing}
        in_util::Union{Float64, Missing}
        in_pps::Union{Float64, Missing}
        out_bps::Union{Float64, Missing}
        out_util::Union{Float64, Missing}
        out_pps::Union{Float64, Missing}
    end

Structure of interface rates returned by [`interfaces_counters_rates`](@ref).

# Fields

| Name          | Description
|:--------------|:------------
| `port`        | Interface name
| `description` | Interface description
| `interval`    | Averagine interval
| `in_bps`      | Inbound bits per second
| `in_util`     | Inbound utilization percentage
| `in_pps`      | Inbound packets per second
| `out_bps`     | Outbound bits per second
| `out_util`    | Outbound utilization percentage
| `out_pps`     | Outbound packets per second
"""
struct InterfacesCountersRates <: AbstractAristaEAPIStruct
   port::String
   description::Union{String, Missing}
   interval::Union{Int, Missing}
   in_bps::Union{Float64, Missing}
   in_util::Union{Float64, Missing}
   in_pps::Union{Float64, Missing}
   out_bps::Union{Float64, Missing}
   out_util::Union{Float64, Missing}
   out_pps::Union{Float64, Missing}
end

function InterfacesCountersRates(ifname, ifstats)
    InterfacesCountersRates(
        string(ifname),
        getas(String, ifstats, :description),
        getas(Int, ifstats, :interval),
        getas(Float64, ifstats, :inBpsRate),
        getas(Float64, ifstats, :inPktsRate),
        getas(Float64, ifstats, :inPpsRate),
        getas(Float64, ifstats, :outBpsRate),
        getas(Float64, ifstats, :outPktsRate),
        getas(Float64, ifstats, :outPpsRate)
    )
end

"""
    interfaces_counters_rates(host[, interfaces]; username, password, protocol)

Return `Vector{InterfacesCountersRates}` of interface counter rates from `host`.

`interfaces` may be given as a comma separated string of interfaces or a Vector
of interfaces to be queried.  If not given, all interfaces will be queried.

`username` and `password` default to `admin`.  `protocol` defaults to `https`,
but may be given as `http` instead.
"""
function interfaces_counters_rates(host, interfaces="";
    username="admin", password="admin", protocol="https"
)
    d = run_command(host, "show interfaces $interfaces counters rates";
        username, password, protocol
    )
    ifdata = d.result[1].interfaces

    map(sort(collect(keys(ifdata)); by=split_numbered)) do ifname
        ifstats = ifdata[ifname]
        InterfacesCountersRates(ifname, ifstats)
    end
end

function interfaces_counters_rates(host, interfaces::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    interfaces_counters_rates(host, join(interfaces, ","); username, password, protocol)
end
