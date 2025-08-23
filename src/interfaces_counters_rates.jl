"""
    interfaces_counters_rates(host[, interfaces]; username, password, protocol)

Return `NamedTuple` of interface counter rates from `host`.

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
        (;
            port        = string(ifname),
            description = getas(String, ifstats, :description),
            interval    = getas(Int, ifstats, :interval),
            in_bps      = getas(Float64, ifstats, :inBpsRate),
            in_util     = getas(Float64, ifstats, :inPktsRate),
            in_pps      = getas(Float64, ifstats, :inPpsRate),
            out_bps     = getas(Float64, ifstats, :outBpsRate),
            out_util    = getas(Float64, ifstats, :outPktsRate),
            out_pps     = getas(Float64, ifstats, :outPpsRate)
        )
    end
end

function interfaces_counters_rates(host, interfaces::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    interfaces_counters_rates(host, join(interfaces, ","); username, password, protocol)
end
