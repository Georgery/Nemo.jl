#=========================================================================
=========================================================================#
module Nemo
#=========================================================================
=========================================================================#

export  bob, bet_this,
        Model1

using Intervals


#=========================================================================
Helper Functions
=========================================================================#

"""
    bob(amount::Float64)

Input a bet amount and return `"bull"` or `"bear"`.
"""
function bob(amount) amount > 0 ? "bear" : "bull" end

#=========================================================================
Model1
=========================================================================#

"""
    Model1

Model containing when to bet how.

# Fields
* `bear_odds` - Vector{`Intervals`} which (when containing a particular value) indicates the...
* `share` - to bet (`Vector{Float64}`)
"""
struct Model1
    bear_odds::Vector{Interval{Float64, Closed, Closed}}
    share::Vector{Float64}
end

function bet_this(request, model::Model1, round_digits = 6)
    _bob_ = "bull"
    amount = 0
    for (i, bear_odds) ∈ enumerate(model.bear_odds)
        if request["bear_odds"] ∈ bear_odds 
            _bob_ = bob(model.share[i])
            amount = round(request["stake"] * abs(model.share[i]), digits = round_digits)
            return Dict("on" => _bob_, "bet" => string(amount))
        end
    end
end



#=========================================================================
=========================================================================#
end # module Nemo
#=========================================================================
=========================================================================#
