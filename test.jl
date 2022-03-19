#=========================================================================
Import the necessary Packages
=========================================================================#

using   Genie, Genie.Router, Genie.Requests, Genie.Renderer.Json,
        Intervals, JLD2
# import Genie.Router: route
# import Genie.Renderer.Json: json

Genie.config.run_as_server = true

#=========================================================================
The Heart of the API
=========================================================================#

# Define the Model1 struct (this needs to go into a separate repo)
struct Model1
    bear_odds::Vector{Interval{Float64, Closed, Closed}}
    shares::Vector{Float64}
end



# Load the Model from Disc
model = load(joinpath("sources", "Model1.jld2"))["model"]

# Define the bet_this() function for this model type (this needs to go into a separate repo)
function bet_this(request, model::Model1)
    _bob_ = "bull"
    amount = 0
    for (i, bear_odds) ∈ enumerate(model.bear_odds)
        if request["bear_odds"] ∈ bear_odds 
            _bob_ = bob(model.shares[i]) |> string
            amount = request["stake"] * abs(model.shares[i])
            break
        end
    end
    return Dict("on" => _bob_, "bet" => string(amount))
end

# this actually needs to stay here
bet_this(request) = bet_this(request, model)

# and this also needs to go to a separate repo
function bob(amount::Float64) amount > 0 ? :bear : :bull end


bet_this(Dict("bear_odds" => 1.4, "stake" => 100.0)) |> json


route("/randomnerds", method = POST) do
    # @show rawpayload()
    # @show jsonpayload()
  
    jsonpayload() |> bet_this |> json
end

model
up()


# HTTP.request("POST", "http://localhost:8000/randomnerds", [("Content-Type", "application/json")], """{"bear_odds":"1.4", "stake":"100.0"}""")

9223372036854775807
1000000000000000001
# Runden auf 10^-6

#=
	
{
  "action": "bet",
  "bearOdds": "2.700140767898604817",
  "blockNumber": 16103559,
  "bullOdds": "1.588186589535178587",
  "currentEpoch": 53343,
  "level": "info",
  "message": "newBlock",
  "secondsUntilLock": 6,
  "totalAmount": "16.155202111168953483"
}

=#