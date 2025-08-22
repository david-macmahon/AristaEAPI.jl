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
    d = run_commands(host, ["show interfaces $interfaces counters rates"];
        username, password, protocol
    )
    ifdata = d.result[1].interfaces

    map(sort(collect(keys(ifdata)); by=numbered)) do ifname
        ifstats = ifdata[ifname]
        #@show ifname ifstats
        (;
            port        = string(ifname),
            description = string(ifstats.description),
            interval    = Int(ifstats.interval),
            inBpsRate   = Float64(ifstats.inBpsRate),
            inPktsRate  = Int(haskey(ifstats, :inPktsRate) ? ifstats.inPktsRate : 0),
            inPpsRate   = Float64(ifstats.inPpsRate),
            outBpsRate  = Float64(ifstats.outBpsRate),
            outPktsRate = Int(haskey(ifstats, :outPktsRate) ? ifstats.outPktsRate : 0),
            outPpsRate  = Float64(ifstats.outPpsRate)
        )
    end
end

function interfaces_counters_rates(host, interfaces::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    interfaces_counters_rates(host, join(interfaces, ","); username, password, protocol)
end
