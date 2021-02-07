function polygon(t, n, len) 
    angle = 360 / n
    polyline(t, n, len, angle) 
end

function polyline(t, n, len, angle)
    for i in 1:n 
        forward(t, len)
        turn(t, -angle) 
    end
end

function arc(t, r, angle) 
    arc_len = 2π * r * abs(angle) / 360 
    n = trunc(arc_len / 4) + 3
    step_len = arc_len / n
    step_angle = angle / n
    turn(t, -step_angle / 2)
    polyline(t, n, step_len, step_angle)
    turn(t, step_angle / 2)
end

function petal(t, r, angle)
    for i in 1:2
        arc(t, r, angle)
        turn(t, angle - 180)
    end
end 
  
function flower(t, n, r, angle)
    for i in 1:n
        petal(t, r, angle)
        turn(t, 360 / n)
    end
end
  
function drawpie(t, n, r)
    polypie(t, n, r)
    penup(t)
    forward(t, r * 2 + 10)
    pendown(t)
end
  
function polypie(t, n, r)
    angle = 360 / n
    for i in 1:n
        isosceles(t, r, angle / 2)
        turn(t, -angle)
    end
end
  
function isosceles(t, r, angle)
    y = r * sin(angle * pi / 180)
    turn(t, angle)
    forward(t, r)
    turn(t, -90 - angle)
    forward(t, 2 * y)
    turn(t, -90 - angle)
    forward(t, r)
    turn(t, -180 + angle)
end
  
function spiral(t, n, len, a, b)
    theta = 0.0
    for i in 1:n
        forward(t, len)
        dtheta = 1 / (a + b * theta)
        turn(t, -dtheta)
        theta += dtheta
    end
end