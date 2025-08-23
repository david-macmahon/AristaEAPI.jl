module AristaEAPITablesExt

import Tables: isrowtable
using AristaEAPI: AbstractAristaEAPIStruct

isrowtable(::Type{T}) where T<:Vector{<:AbstractAristaEAPIStruct} = true

end # module AristaEAPITablesExt
