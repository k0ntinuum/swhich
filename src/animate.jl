function animate_update(f,p,c)
    x = div(length(f[1,:]),2) + 1
    down = 2
    left = 2
    alph = "O|\u2594"
    #alph = "ABCDEFGHIJKLMNOPQRSTUVWXYZ_"
    n = length(f[1,:])
    cursor_to(down, left + 2*x)
    print(alph[p+1])
    for i in 1:n
        cursor_to(down + 1, left + 2*i)
        print(rgb(0,rand(0:255),0))
        print(alph[f[1,i]+1])
        cursor_to(down + 2, left + 2*i)
        print(rgb(0,rand(0:255),0))
        print(alph[f[2,i]+1])
    end
    cursor_to(down+3, left + 2*x)
    print(alph[c+1])
end


function animate(b,n)
    hide_cursor()
    cls()
    f = key(b,n)
    x = div(length(f[1,:]),2) + 1
    for i in 1:1000000000
        p = rand(0:b-1)
        c = ( center(f) + p )  % b
        animate_update(f,p,c)
        sleep(0.14)  
        f[1,:] = circshift(f[1,:], p + 1 )
        f[2,:] = circshift(f[2,:], - (c + 1 ))
        t = f[1,x]; f[1,x] = f[2,x]; f[2,x] = t
    end
    show_cursor()
end
