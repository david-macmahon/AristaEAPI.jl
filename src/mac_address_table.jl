"""
    struct MACAddressRecord <: AbstractAristaEAPIStruct
        vlan::Union{Int, Missing}
        mac_address::Union{String, Missing}
        type::Union{String, Missing}
        port::Union{String, Missing}
        moves::Union{Int, Missing}
        last_move::Union{Float64, Missing}
    end

Structure of MAC address info returned by [`mac_address_table`](@ref).

# Fields

| Name          | Description
|:--------------|:------------
| `vlan`        | VLAN ID
| `mac_address` | MAC address
| `type`        | Indicates learned (`"dynamic"`) or configured (`"static"`)
| `port`        | Interface name
| `moves`       | Number of times the MAC address has changed ports
| `last_move`   | Last time the MAC address changed ports (UNIX seconds)
"""
struct MACAddressRecord <: AbstractAristaEAPIStruct
    vlan::Union{Int, Missing}
    mac_address::Union{String, Missing}
    type::Union{String, Missing}
    port::Union{String, Missing}
    moves::Union{Int, Missing}
    last_move::Union{Float64, Missing}
end

function MACAddressRecord()
    MACAddressRecord(
        getas(Int, mac, :vlanId),
        getas(String, mac, :macAddress),
        getas(String, mac, :entryType),
        getas(String, mac, :interface),
        getas(Int, mac, :moves),
        getas(Float64, mac, :lastMove)
    )
end

"""
    isdynamic(mac::MACAddressRecord) -> Bool

Predicate function that returns `mac.type == "dynamic`
"""
isdynamic(mac::MACAddressRecord) = mac.type == "dynamic"

"""
    isstatic(mac::MACAddressRecord) -> Bool

Predicate function that returns `mac.type == "static`
"""
isstatic(mac::MACAddressRecord) = mac.type == "static"

"""
    mac_address_table(host[, interfaces]; address, username, password, protocol)

Return `Vector{MACAddressRecord}` of the unitcast MAC address table of `host`.

`interfaces` may be given as a comma separated string of interfaces or a Vector
of interfaces to be queried.  If not given, all interfaces will be queried.
Optionally, a MAC address may be passed as `address` to query for a specific MAC
address.

`username` and `password` default to `admin`.  `protocol` defaults to `https`,
but may be given as `http` instead.
"""
function mac_address_table(host, interfaces=""; address="",
    username="admin", password="admin", protocol="https"
)
    d = run_command(host, "show mac address-table " *
            (isempty(address) ? "" : "address $address") *
            (isempty(interfaces) ? "" : "interface $interfaces");
        username, password, protocol
    )
    macdata = d.result[1].unicastTable.tableEntries
    map(MACAddressRecord, macdata)
end

function mac_address_table(host, interfaces::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    mac_address_table(host, join(interfaces, ","); username, password, protocol)
end
