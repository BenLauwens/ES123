module ES123Chess

    using Luxor
    using Colors
    using Crayons

    export play

    mutable struct Chess
        board :: Array{Char, 2}
        whitemove :: Bool

        function Chess()
            board = Array{Char, 2}(8, 8)
            fill!(board, ' ')
            board[1,1] = '♖'
            board[2,1] = '♘'
            board[3,1] = '♗'
            board[4,1] = '♕'
            board[5,1] = '♔'
            board[6,1] = '♗'
            board[7,1] = '♘'
            board[8,1] = '♖'
            for i in 1:8
                board[i, 2] = '♙'
                board[i, 7] = '♟'
            end
            board[1,8] = '♜'
            board[2,8] = '♞'
            board[3,8] = '♝'
            board[4,8] = '♛'
            board[5,8] = '♚'
            board[6,8] = '♝'
            board[7,8] = '♞'
            board[8,8] = '♜'
            new(board, true)
        end
    end

    function Base.show(io::IO, chess::Chess)
        light = true
        for i in 8:-1:1
            print(io, Crayon(reset = true), i)
            for j in 1:8
                if light
                    print(io, " ", Crayon(foreground=(0, 0, 0), background=(255, 204, 153)), chess.board[j, i])
                    light = false
                else
                    print(io, " ", Crayon(foreground=(0, 0, 0), background=(255, 153, 51)), chess.board[j, i])
                    light = true
                end
            end
            println(io, " ", Crayon(reset=true))
            light = !light
        end
        print(io, Crayon(reset = true), "  a b c d e f g h")
    end

    function draw(chess::Chess)
        t = Table(10, 10, 50, 50)
        setcolor("gray")
        for i in 1:8
            for j in 1:8
                if i % 2 == 0 && j % 2 == 1 || i % 2 == 1 && j % 2 == 0
                    setcolor("navajowhite")
                else
                    setcolor("sandybrown")
                end
                n = 10*(9-i)+j+1 
                box(t[n], t.colwidths[t.currentcol], t.rowheights[t.currentrow], :fill)
            end
        end
        setcolor("black")
        for i in 1:8
            for j in 1:8
                n = 10*(9-i)+j+1
                fontsize(t.rowheights[t.currentrow]*2/3)
                text(string(chess.board[j, i]), t[n]-(5,0), halign=:center, valign=:middle)
            end
        end
        for i in 1:8
            n = 10*(9-i)+1
            fontsize(t.rowheights[t.currentrow]/2)
            text(string(i), t[n], halign=:center, valign=:middle)
        end
        for (j, c) in enumerate("abcdefgh")
            n = 91+j
            fontsize(t.rowheights[t.currentrow]/2)
            text(string(c), t[n], halign=:center, valign=:middle)
        end
    end

    function domove(chess::Chess, move::String)
        x₀, y₀, x₁, y₁, capture = parsemove(move)
        if !isvalidmove(chess, x₀, y₀, x₁, y₁, capture)
            error("Move is not valid!")
        end
        chess.board[x₁, y₁] = chess.board[x₀, y₀]
        chess.board[x₀, y₀] = ' '
        chess.whitemove = !chess.whitemove
        nothing
    end

    function parsemove(move::String)
        x₀ = Int(move[1])-96
        y₀ = parse(Int, move[2])
        x₁ = Int(move[3])-96
        y₁ = parse(Int, move[4])
        capture = ' '
        if length(move) == 5
            capture = move[5]
        end
        @assert(1 ≤ x₀ ≤ 8, "Movement can not be parsed!")
        @assert(1 ≤ y₀ ≤ 8, "Movement can not be parsed!")
        @assert(1 ≤ x₁ ≤ 8, "Movement can not be parsed!")
        @assert(1 ≤ y₁ ≤ 8, "Movement can not be parsed!")
        x₀, y₀, x₁, y₁, capture
    end

    function isvalidmove(chess::Chess, x₀::Int64, y₀::Int64, x₁::Int64, y₁::Int64, capture::Char)
        piece = chess.board[x₀, y₀]
        if chess.whitemove
            if piece == '♙'
                if isverticalmove(x₀, y₀, x₁, y₁) && movedistance(x₀, y₀, x₁, y₁, true) == 1
                    return chess.board[x₁, y₁] == ' '
                elseif isverticalmove(x₀, y₀, x₁, y₁) && y₀ == 2 && movedistance(x₀, y₀, x₁, y₁, true) == 2
                    if nopiecesinbetween(chess, x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] == ' '
                    end
                elseif isdiagonalmove(x₀, y₀, x₁, y₁) && movedistance(x₀, y₀, x₁, y₁, true) == 2
                    return chess.board[x₁, y₁] ∈ "♜♞♝♛♚♟"
                end
            elseif piece == '♗'
                if isdiagonalmove(x₀, y₀, x₁, y₁)
                    if nopiecesinbetween(chess, x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] ∈ " ♜♞♝♛♚♟"
                    end
                end
            elseif piece == '♖'
                if isverticalmove(x₀, y₀, x₁, y₁) || ishorizontalmove(x₀, y₀, x₁, y₁)
                    if nopiecesinbetween(chess, x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] ∈ " ♜♞♝♛♚♟"
                    end
                end
            elseif piece == '♘'
                if movedistance(x₀, y₀, x₁, y₁) == 3 && !ishorizontalmove(x₀, y₀, x₁, y₁) &&
                    !isverticalmove(x₀, y₀, x₁, y₁) && !isdiagonalmove(x₀, y₀, x₁, y₁)
                    return chess.board[x₁, y₁] ∈ " ♜♞♝♛♚♟"
                end
            elseif piece == '♕'
                if isverticalmove(x₀, y₀, x₁, y₁) || ishorizontalmove(x₀, y₀, x₁, y₁) || 
                    isdiagonalmove(x₀, y₀, x₁, y₁)
                    if nopiecesinbetween(chess, x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] ∈ " ♜♞♝♛♚♟"
                    end
                end
            elseif piece == '♔'
                if 1 ≤ movedistance(x₀, y₀, x₁, y₁) ≤ 2
                    return chess.board[x₁, y₁] ∈ " ♜♞♝♛♚♟"
                end
            end
        else
            if piece == '♟'
                if isverticalmove(x₀, y₀, x₁, y₁) && movedistance(x₀, y₀, x₁, y₁, true) == -1
                    return chess.board[x₁, y₁] == ' '
                elseif isverticalmove(x₀, y₀, x₁, y₁) && y₀ == 7 && movedistance(x₀, y₀, x₁, y₁, true) == -2
                    if nopiecesinbetween(chess, x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] == ' '
                    end
                elseif isdiagonalmove(x₀, y₀, x₁, y₁) && movedistance(x₀, y₀, x₁, y₁, true) == 2
                    return chess.board[x₁, y₁] ∈ "♖♘♗♕♔♙"
                end
            elseif piece == '♝'
                if isdiagonalmove(x₀, y₀, x₁, y₁)
                    if nopiecesinbetween(chess, x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] ∈ " ♖♘♗♕♔♙"
                    end
                end
            elseif piece == '♜'
                if isverticalmove(x₀, y₀, x₁, y₁) || ishorizontalmove(x₀, y₀, x₁, y₁)
                    if nopiecesinbetween(chess, x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] ∈ " ♖♘♗♕♔♙"
                    end
                end
            elseif piece == '♞'
                if movedistance(x₀, y₀, x₁, y₁) == 3 && !ishorizontalmove(x₀, y₀, x₁, y₁) &&
                    !isverticalmove(x₀, y₀, x₁, y₁) && !isdiagonalmove(x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] ∈ " ♖♘♗♕♔♙"
                end
            elseif piece == '♛'
                if isverticalmove(x₀, y₀, x₁, y₁) || ishorizontalmove(x₀, y₀, x₁, y₁) || 
                    isdiagonalmove(x₀, y₀, x₁, y₁)
                    if nopiecesinbetween(chess, x₀, y₀, x₁, y₁)
                        return chess.board[x₁, y₁] ∈ " ♖♘♗♕♔♙"
                    end
                end
            elseif piece == '♚'
                if 1 ≤ movedistance(x₀, y₀, x₁, y₁) ≤ 2
                    return chess.board[x₁, y₁] ∈ " ♖♘♗♕♔♙"
                end
            end
        end
        false
    end

    function movedistance(x₀::Int64, y₀::Int64, x₁::Int64, y₁::Int64, oriented::Bool=false)
        if oriented
            return x₁-x₀ + y₁-y₀
        end
        abs(x₁-x₀) + abs(y₁-y₀)
    end

    function isverticalmove(x₀::Int64, y₀::Int64, x₁::Int64, y₁::Int64)
       x₀ == x₁ && y₀ ≠ y₁
    end

    function ishorizontalmove(x₀::Int64, y₀::Int64, x₁::Int64, y₁::Int64)
       x₀ ≠ x₁ && y₀ == y₁
    end

    function isdiagonalmove(x₀::Int64, y₀::Int64, x₁::Int64, y₁::Int64)
        x₀ ≠ x₁ && y₀ ≠ y₁ && max(x₀, x₁) - min(x₀, x₁) == max(y₀, y₁) - min(y₀, y₁)
    end

    function nopiecesinbetween(chess::Chess, x₀::Int64, y₀::Int64, x₁::Int64, y₁::Int64)
        δx = sign(x₁ - x₀)
        δy = sign(y₁ - y₀)
        n = max(abs(x₁ - x₀), abs(y₁ - y₀))
        x = x₀
        y = y₀
        println(δx, ", ", δy, ": ", n)
        for i in 1:n-1
            x = x + δx
            y = y + δy
            if chess.board[x, y] ≠ ' '
                return false
            end
        end
        true
    end

    function play(gui::Bool=false)
        chess = Chess()
        msg = ""
        str = ""
        while true
            if chess.whitemove
                msg = "White move: $msg"
            else
                msg = "Black move: $msg"
            end
            if gui
                @svg begin
                    draw(chess)
                    text(msg, Point(-230, -220))
                end 480 480
                print(" ")
                flush(STDOUT)
                str = readline()
            else
                println(chess)
                print(msg)
                str = readline()
                println()
            end
            if str == "done"
                break
            end
            try
                domove(chess, str)
                msg = ""
            catch
                msg = "$str is not valid! "
            end
        end
    end
end