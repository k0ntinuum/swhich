using Random
using Printf
using OhMyREPL

include("tg.jl")
include("demo.jl")
include("animate.jl")

function key(b,n)
    rand(0:b-1,2,n)
end

function center(f)
    c = div(length(f[1,:]),2) + 1
    f[1,c]+f[2,c]
end

function encode(p,f,key_base)
    c = zeros(Int64, length(p))
    x = div(length(f[1,:]),2) + 1
    for i in eachindex(p)
        c[i] = ( center(f) + p[i] )  % key_base    
        t = f[1,x]; f[1,x] = f[2,x]; f[2,x] = t
        f[1,:] = circshift(f[1,:], p[i] + 1 )
        f[2,:] = circshift(f[2,:], - (c[i] + 1 ))
    end
    c
end

function decode(c,f,key_base)
    p = zeros(Int64, length(c))
    x = div(length(f[1,:]),2) + 1
    for i in eachindex(c)
        p[i] = ( 2*key_base + c[i] - center(f) ) % key_base
        t = f[1,x]; f[1,x] = f[2,x]; f[2,x] = t
        f[1,:] = circshift(f[1,:], p[i] + 1 )
        f[2,:] = circshift(f[2,:], - (c[i] + 1 ))
    end
    p
end

function encrypt(p, q, key_base)
    n = length(f[1,:])
    for i in 1:n
        f = circshift(deepcopy(q), i)
        p = encode(p,f, key_base)
        p = reverse(p)
    end
    p
end


function decrypt(p, q,key_base)
    n = length(f[1,:])
    for i in 1:n
        f = deepcopy(q)
        f = circshift(deepcopy(q), n - 1 - i)
        p = reverse(p)
        p = decode(p, f ,key_base)
    end
    p
end

function demo()
    cls()
    key_base = 27
    key_length = 17
    text_length = 54
    f = key(key_base,key_length)
    #f = map(i -> i - 1, randperm(27))
    print(white(),"f  = ", gray(255),str_from_vec(f[1,:],""),"\n")
    print(white(),"     ", gray(255),str_from_vec(f[2,:],""),"\n\n")
    for i in 1:7
        p = rand(0:key_base-1,text_length )
        print(white(),"p  = ",red(), str_from_vec(p,""),"\n")
        c = encrypt(p, f, key_base)
        print(white(),"c  = ",yellow(), str_from_vec(c,""),"\n")
        e = map(i -> (key_base + c[i] - p[i])%key_base, collect(1:text_length)) 
        d = decrypt(c, f , key_base)
        print(white(),"d  = ", gray(100),str_from_vec(d,""),"\n\n")
        if p != d print("\nERROR\n") end
    end
    print(white())
end







