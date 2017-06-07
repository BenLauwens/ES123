from time import clock

start = 0.0

def tic():
    global start
    start = clock()

def toc():
    global start
    diff = clock() - start
    print("elapsed time: {:f} seconds".format(diff))
