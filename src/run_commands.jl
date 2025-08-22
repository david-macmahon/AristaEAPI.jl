"""
    run_commands(host, cmds::AbstractVector; username, password, protocol)

Run Arista commands `cmds` on `host` using Arista EAPI.

`username` and `password` default to `admin`.  `protocol` defaults to `https`,
but may be given as `http` instead.
"""
function run_commands(host, cmds::AbstractVector;
    username="admin", password="admin", protocol="https"
)
    id = "AristaEAPI.jl-$(randstring(8))"

    jsonrpc = Dict(
        "jsonrpc" => "2.0",
        "method" => "runCmds",
        "params" => Dict(
            "version" => 1,
            "cmds" => cmds,
        ),
        "id" => id
    )

    url = "$protocol://$host/command-api"
    input = IOBuffer(JSON3.write(jsonrpc))
    output = IOBuffer()
    authorization = base64encode("$username:$password")

    resp = withenv("JULIA_SSL_NO_VERIFY_HOSTS"=>host) do
        request(url;
            method = "POST",
            input,
            output,
            headers = ["Authorization" => "Basic $authorization"]
        )
    end

    # If response does not have a 2xx status
    if !Downloads.Curl.PROTOCOL_STATUS["http"](resp.status)
        throw(RequestError(resp.url, resp.status, resp.message, resp))
    end

    d = JSON3.read(seekstart(output))

    if haskey(d, :error)
        throw(RequestError(resp.url, d.error.code, d.error.message, resp))
    end

    if d.id != id
        error("response id did not match request id")
    end

    d
end

"""
    run_command(host, cmd::AbstractString; username, password, protocol)

Run Arista command `cmd` on `host` using Arista EAPI.

`username` and `password` default to `admin`.  `protocol` defaults to `https`,
but may be given as `http` instead.
"""
function run_command(host, cmd::AbstractString;
    username="admin", password="admin", protocol="https"
)
    run_commands(host, [cmd]; username, password, protocol)
end
