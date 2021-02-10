function koch(t, x)
    if x < 3
        forward(t, x)
    else
        koch(t, x / 3)
        turn(t, -60)
        koch(t, x / 3)
        turn(t, 120)
        koch(t, x / 3)
        turn(t, -60)
        koch(t, x / 3)
    end
end