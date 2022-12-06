function nestedsum(array_or_integer)
    if array_or_integer isa Integer
        array_or_integer
    else
        count = 0
        for element in array_or_integer
            count += nestedsum(element)
        end
        count
    end
end

function cumulsum(array)
    cumul = copy(array)
    for i in 2:length(array)
        cumul[i] += cumul[i-1]
    end
    cumul
end

interior(array) = array[begin+1:end-1]

function interior!(array)
    popfirst!(array)
    pop!(array)
    nothing
end

function issort(array)
    for i in 2:length(array)
        prev = array[i-1]
        next = array[i]
        if prev > next return false end
    end
    true
end
