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



"""
    valid_request(r, m::Model[...])

Check if the `r`equest has the correct format. Besides the request `r` this
function also takes the relevant model as input, so it can check for the necessary 
fields depending on the model version.
"""
function valid_request(r, m::Model1)
    try
        haskey(r, "bearOdds") &&
        haskey(r, "stake") &&
        r["bearOdds"] isa Number &&
        r["stake"] isa Number
    catch
        false
    end
end



"""
    bet_this(request, m::Model[...], round_digits = 6)

What amount should be bet on what.

# Arguments
* `request` - A `Dict`ionary that contains the correct fields.
* `m` - Model that is applied to the request (`Model1`, `Model2`...)
* `round_digits` - `Integer` containing the number of digits the resulting amount shall
    be rounded to, to make "don't-bet"s possible.
"""
function bet_this(request, m::Model1, round_digits = 6)
    valid_request(request, m) && return Dict("on" => "bull", "bet" => "0.0")
    _bob_ = "bull"
    amount = 0
    for (i, bear_odds) ∈ enumerate(m.bear_odds)
        if request["bearOdds"] ∈ bear_odds 
            _bob_ = bob(m.share[i])
            amount = round(request["stake"] * abs(m.share[i]), digits = round_digits)
            return Dict("on" => _bob_, "bet" => string(amount))
        end
    end
end



#=========================================================================
=========================================================================#
end # module Nemo
#=========================================================================
=========================================================================#
