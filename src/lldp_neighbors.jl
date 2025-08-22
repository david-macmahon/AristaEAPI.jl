"""
    lldp_neighbors(host[, interfaces]; username, password, protocol)

Return `NamedTuple` of LLDP neighbors of `host`.

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

    map(lldpdata) do lldp
        (;
            port            = string(lldp.port),
            neighbor_device = string(lldp.neighborDevice),
            neighbor_port   = string(lldp.neighborPort),
            ttl             = Int(lldp.ttl)
        )
    end
end

function lldp_neighbors(host, interfaces::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    lldp_neighbors(host, join(interfaces, ","); username, password, protocol)
end
