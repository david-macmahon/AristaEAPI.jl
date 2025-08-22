"""
    mac_address_table(host[, interfaces]; address, username, password, protocol)

Return `NamedTuple` of the unitcase mac address table of `host`.

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
    d = run_commands(host, ["show mac address-table " *
            (isempty(address) ? "" : "address $address") *
            (isempty(interfaces) ? "" : "interface $interfaces")];
        username, password, protocol
    )
    macdata = d.result[1].unicastTable.tableEntries
    map(macdata) do mac
        (;
            vlan        = Int(mac.vlanId),
            mac_address = string(mac.macAddress),
            type        = string(mac.entryType),
            port        = string(mac.interface),
            moves       = Int(mac.moves),
            last_move   = Float64(mac.lastMove)
        )
    end
end

function mac_address_table(host, interfaces::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    mac_address_table(host, join(interfaces, ","); username, password, protocol)
end
