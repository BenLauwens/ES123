function mysqrt(a, x)
    while true
        y = 0.5(x + a/x)
        if abs(y - x) < eps() break end
        x = y
    end
    x
end

function testsquareroot()
    println("a", " "^3, "mysqrt", " "^13, "sqrt", " "^15, "diff")
    println("-", " "^3, "------", " "^13, "----", " "^15, "----")
    for a in 1.0:9.0
        mysqrt_value = mysqrt(a, 2.0)
        sqrt_value = sqrt(a)
        diff = abs(mysqrt_value - sqrt_value)
        mysqrt_len = length(string(mysqrt_value))
        sqrt_len = length(string(sqrt_value))
        println(a, " ", mysqrt_value, " "^(19-mysqrt_len), sqrt_value, " "^(19-sqrt_len), diff)
    end
end
