"""
    struct LLDPNeighbors <: AbstractAristaEAPIStruct
        port::Union{String, Missing}
        neighbor_device::Union{String, Missing}
        neighbor_port::Union{String, Missing}
        ttl::Union{Int, Missing}
    end

Structure of LLDP neighbor info returned by [`lldp_neighbors`](@ref).

# Fields

| Name              | Description
|:------------------|:------------
| `port`            | Interface name
| `neighbor_device` | Neighbor name
| `neighbor_port`   | Neighbor interface
| `ttl`             | Time to live
"""
struct LLDPNeighbors <: AbstractAristaEAPIStruct
    port::Union{String, Missing}
    neighbor_device::Union{String, Missing}
    neighbor_port::Union{String, Missing}
    ttl::Union{Int, Missing}
end

function LLDPNeighbors(lldp)
    LLDPNeighbors(
        getas(String, lldp, :port),
        getas(String, lldp, :neighborDevice),
        getas(String, lldp, :neighborPort),
        getas(Int, lldp, :ttl)
    )
end

"""
    lldp_neighbors(host[, interfaces]; username, password, protocol)

Return `Vector{LLDPNeighbors}` of LLDP neighbors of `host`.

`interfaces` may be given as a comma separated string of interfaces or a Vector
of interfaces to be queried.  If not given, all interfaces will be queried.

`username` and `password` default to `admin`.  `protocol` defaults to `https`,
but may be given as `http` instead.
"""
function lldp_neighbors(host, interfaces="";
    username="admin", password="admin", protocol="https"
)
    d = run_command(host, "show lldp neighbors $interfaces";
        username, password, protocol
    )
    lldpdata = d.result[1].lldpNeighbors

    map(LLDPNeighbors, lldpdata)
end

function lldp_neighbors(host, interfaces::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    lldp_neighbors(host, join(interfaces, ","); username, password, protocol)
end
