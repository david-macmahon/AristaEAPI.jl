module AristaEAPIPrettyTablesExt

import PrettyTables: pretty_table
using AristaEAPI: InterfacesCountersRates, LLDPNeighbors, MACAddressRecord

function pretty_table(table::Vector{InterfacesCountersRates};
    alignment=[:l; :l; fill(:r,7)],
    alignment_anchor_regex=Dict(3:9 .=> Ref([r"\."])),
    crop=:none,
    kwargs...
)
    invoke(pretty_table, Tuple{Any}, table;
        alignment,
        alignment_anchor_regex,
        crop,
        kwargs...
    )
end

function pretty_table(table::Vector{LLDPNeighbors};
    alignment=[:l, :l, :l, :r],
    crop=:none,
    kwargs...
)
    invoke(pretty_table, Tuple{Any}, table;
        alignment,
        crop,
        kwargs...
    )
end

function pretty_table(table::Vector{MACAddressRecord};
    alignment=[:r, :l, :c, :l, :r, :r],
    crop=:none,
    kwargs...
)
    invoke(pretty_table, Tuple{Any}, table;
        alignment,
        crop,
        kwargs...
    )
end

end # module AristaEAPIPrettyTablesExt
