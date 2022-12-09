using Printf

function printtime(time)
    @printf "%0.2u:%0.2u:%0.2u" time.hour time.minute time.second
end
