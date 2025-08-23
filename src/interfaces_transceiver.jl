"""
    struct InterfacesTransceiver <: AbstractAristaEAPIStruct
        port::String
        temperature::Union{Float64, Missing}
        voltage::Union{Float64, Missing}
        bias_current::Union{Float64, Missing}
        tx_power::Union{Float64, Missing}
        rx_power::Union{Float64, Missing}
        last_update::Union{Float64, Missing}
        media_type::Union{String, Missing}
        vendor_sn::Union{String, Missing}
        narrowband::Union{Bool, Missing}
    end

Structure of transceiver status info returned by
[`interfaces_transceiver`](@ref).

# Fields

| Name           | Description
|:---------------|:------------
| `port`         | Interface name
| `temperature`  | Transceiver temperature (C)
| `voltage`      | Transceiver voltage (V)
| `bias_current` | Transceiver bias current (mA)
| `tx_power`     | Optical transmit power (dBm)
| `rx_power`     | Optical receive power (dBm)
| `last_update`  | Last update time (UNiX seconds)
| `media_type`   | Media type (e.g. `40GBASE-SR4`)
| `vendor_sn`    | Transceiver serial number
| `narrowband`   | Narrowband transceiver
"""
struct InterfacesTransceiver <: AbstractAristaEAPIStruct
    port::String
    temperature::Union{Float64, Missing}
    voltage::Union{Float64, Missing}
    bias_current::Union{Float64, Missing}
    tx_power::Union{Float64, Missing}
    rx_power::Union{Float64, Missing}
    last_update::Union{Float64, Missing}
    media_type::Union{String, Missing}
    vendor_sn::Union{String, Missing}
    narrowband::Union{Bool, Missing}
end

function InterfacesTransceiver(ifstats)
    InterfacesTransceiver(
        string(ifname),
        getas(Float64, ifstats, :temperature),
        getas(Float64, ifstats, :voltage),
        getas(Float64, ifstats, :txBias),
        getas(Float64, ifstats, :txPower),
        getas(Float64, ifstats, :rxPower),
        getas(Float64, ifstats, :updateTime),
        getas(String, ifstats, :mediaType),
        getas(String, ifstats, :vendorSn),
        getas(Bool, ifstats, :narrowBand)
    )
end

"""
    interfaces_transceiver(host[, interfaces]; username, password, protocol)

Return `NamedTuple` of interface transceiver status from `host`.

`interfaces` may be given as a comma separated string of interfaces or a Vector
of interfaces to be queried.  If not given, all interfaces will be queried.

`username` and `password` default to `admin`.  `protocol` defaults to `https`,
but may be given as `http` instead.
"""
function interfaces_transceiver(host, interfaces="";
    username="admin", password="admin", protocol="https"
)
    d = run_command(host, "show interfaces $interfaces transceiver";
        username, password, protocol
    )
    data = d.result[1].interfaces

    nts = map(sort(collect(keys(data)); by=split_numbered)) do ifname
        ifstats = data[ifname]
        (;
            port         = string(ifname),
            temperature  = getas(Float64, ifstats, :temperature),
            voltage      = getas(Float64, ifstats, :voltage),
            bias_current = getas(Float64, ifstats, :txBias),
            tx_power     = getas(Float64, ifstats, :txPower),
            rx_power     = getas(Float64, ifstats, :rxPower),
            last_update  = getas(Float64, ifstats, :updateTime),
            media_type   = getas(String, ifstats, :mediaType),
            vendor_sn    = getas(String, ifstats, :vendorSn),
            narrowband   = getas(Bool, ifstats, :narrowBand)
        )
    end

    # Exclude interfaces with no last update time
    filter(nt->!ismissing(nt.last_update), nts)
end

function interfaces_transceiver(host, interfaces::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    interfaces_transceiver(host, join(interfaces, ","); username, password, protocol)
end
