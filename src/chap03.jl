function rightjustify(str)
    len = length(str)
    println(" "^(70-len) * str)
end

function printbordercell()
    print("+ - - - - ")
end

function printcell()
    print("|         ")
end

function printborderline()
    printbordercell()
    printbordercell()
    println("+")
end

function printline()
    printcell()
    printcell()
    println("|")
end

function printrow()
    printborderline()
    printline()
    printline()
    printline()
    printline()
end

function printgrid()
    printrow()
    printrow()
    printborderline()
end
