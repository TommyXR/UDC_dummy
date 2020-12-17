module datafeed


using Sockets
using Dates

using HTTP
using JSON


struct Exchange
    value::Symbol
    name::String
    desc::String
end

struct SymbolType
    name::String
    value::String
end


struct DataFeedConfig
    exchanges::Vector{Exchange}
    symbols_types::Vector{SymbolType}
    supported_resolutions::Vector{String}
    currency_codes::Vector{Symbol}
    supports_marks::Bool
    supports_timescale_marks::Bool
    supports_time::Bool
    supports_search::Bool
    supports_group_request::Bool
end


const DEFAULT_CONFIG = DataFeedConfig(
    [],
    [],
    ["1"],
    [:CAD],
    false,
    false,
    true,
    true,
    false
)


get_config(req::HTTP.Request) = DEFAULT_CONFIG


# # # # #


function symbol_resolve(req::HTTP.Request)

    @warn "Implement symbol_resolve you fool."

    return """{"name":"AAL",
    "exchange-traded":"NasdaqNM",
    "exchange-listed":"NasdaqNM",
    "timezone":"America/New_York",
    "minmov":1,
    "minmov2":0,
    "pointvalue":1,
    "session":"0930-1630",
    "has_intraday":false,
    "has_no_volume":false,
    "description":"American Airlines Group Inc.",
    "type":"stock",
    "supported_resolutions":["D","2D","3D","W","3W","M","6M"],
    "pricescale":100,"ticker":"AAL"}"""

end


function symbol_search(req::HTTP.Request)

    @warn "Implement symbol_search you fool."
    
    return """[{"name":"AAL",
    "exchange-traded":"NasdaqNM",
    "exchange-listed":"NasdaqNM",
    "timezone":"America/New_York",
    "minmov":1,
    "minmov2":0,
    "pointvalue":1,
    "session":"0930-1630",
    "has_intraday":false,
    "has_no_volume":false,
    "description":"American Airlines Group Inc.",
    "type":"stock",
    "supported_resolutions":["D","2D","3D","W","3W","M","6M"],
    "pricescale":100,"ticker":"AAL"}]"""

end


function symbol_data(req::HTTP.Request)

    @warn "Implement symbol_data you fool."

    return json(Dict(
        :s => :ok,
        :t => [1386493512, 1386493572, 1386493632, 1386493692],
        :c => [42.1, 43.4, 44.3, 42.8]
    ))

end



function quotes(req::HTTP.Request)

    @warn "Implement quotes you fool."

    return """
    {
    "s": "ok",
    "d": [
        {
            "s": "ok",
            "n": "NYSE:AA",
            "v": {
                "ch": "+0.16",
                "chp": "0.98",
                "short_name": "AA",
                "exchange": "NYSE",
                "description": "Alcoa Inc. Common",
                "lp": "16.57",
                "ask": "16.58",
                "bid": "16.57",
                "open_price": "16.25",
                "high_price": "16.60",
                "low_price": "16.25",
                "prev_close_price": "16.41",
                "volume": "4029041"
            }
        },
        {
            "s": "ok",
            "n": "NYSE:F",
            "v": {
                "ch": "+0.15",
                "chp": "0.89",
                "short_name": "F",
                "exchange": "NYSE",
                "description": "Ford Motor Company",
                "lp": "17.02",
                "ask": "17.03",
                "bid": "17.02",
                "open_price": "16.74",
                "high_price": "17.08",
                "low_price": "16.74",
                "prev_close_price": "16.87",
                "volume": "7713782"
            }
        }
    ]
}
"""

end


# # # # #


# Maybe we want the time of the DB and not this small API instead?

seconds_since_epoch(req::HTTP.Request) = round(Int, time())


# # # # #


const ROUTER = HTTP.Router()

HTTP.@register ROUTER "GET" "/config" json∘get_config

HTTP.@register ROUTER "GET" "/symbols" symbol_resolve
HTTP.@register ROUTER "GET" "/search" symbol_search

HTTP.@register ROUTER "GET" "/time" json∘seconds_since_epoch


if !isinteractive()

    length(ARGS) != 1 && (println("Please pass the port number as the only argument."); exit(1))

    port = parse(Int, first(ARGS))

    @info "Starting serving on port $port."

    HTTP.serve(ROUTER, Sockets.localhost, port)

end


end # module
