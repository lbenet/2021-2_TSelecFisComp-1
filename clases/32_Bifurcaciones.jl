# # La ruta al caos de doblamiento de periodo

using Pkg
Pkg.activate("..")

#-
using Plots
gr(grid=false)

#-
# ## Más allá del atractor de periodo 2
# 
# En la clase anterior, vimos que en la familia de mapeos cuadrática 
# $Q_c(x) = x^2+c$ hay *al menos* dos bifurcaciones que ocurren.
# 
# - Para $c>1/4$, no hay puntos fijos en el mapeo, y que para $c<1/4$ hay dos que, para valores de $c$ suficientemente cercanos a $c=1/4$ corresponden a un atractor y a un repulsor. Esta bifurcación es la de silla-nodo.
# - Para $c<-3/4$ vimos que el punto fijo atractor se torna repulsor y *aparecen* dos puntos periódicos, de periodo 2, que son atractores. La bifurcación que ocurre en $c=-3/4$ es la que se llama la bifurcación de doblamiento de periodo.
# - Además, vimos que para $c<-5/4$ los dos puntos del ciclo de periodo dos se tornan repulsores.

#-
# El ejercicio 3 del archivo anterior trataba de explorar los detalles 
# de lo que pasaba en el intervalo $-2\le c<1/4$ de manera íntegra. La 
# razón por la que nos concentramos en el intervalo con $1/4\ge c\ge -2$ 
# es que, en este caso el intervalo de $x \in \mathcal{D}$ se mapea sobre 
# sí mismo.

#-
# Ahora esbozaremos una posible implementación de ese ejercicio. Una 
# sutileza: utilizaremos como condición inicial a $x_0=0$. Vale la pena 
# notar que este punto tiene una peculiaridad importante: $Q_c'(0)=0$ 
# (y $Q_c''(0)\neq 0$). Esto es, si $x_0=0$ es un punto crítico del 
# mapeo $Q_c(x)$, para alguna $c$, entonces, si $x_0=0$ pertenece 
# a una órbita periódica, en ese caso la órbita será *superestable*.

#-
"""
    ciclosestables!(xx, f, cc, nit, nout)

Esta función itera el mapeo `f`, de una variable, `nit+nout` veces,
usando como condición inicial `x0=0`; los últimos `nout` iterados
actualizan al vector `xx` que tiene longitud `nout`. `cc` es el valor
del parámetro del mapeo `f`. El mapeo `f` debe ser definido de
tal manera que `f(x0, cc)` tenga sentido. La idea es que los últimos
`nout` iterados reflejen los ciclos estables del mapeo `f`.
"""
function ciclosestables!(xx, f, cc, nit, nout)
    @assert (nit > 0) && (nout > 0)

    #Primeros nit iterados
    x0 = 0.0
    for it = 1:nit
        x0 = f(x0, cc)
    end

    #Se guardan los siguientes nout iterados
    for it = 1:nout
        x0 = f(x0, cc)
        @inbounds xx[it] = x0
    end

    nothing
end

#-
"""
    diag_bifurc(f, nit, nout, crange)

Itera el mapeo `f` `nit+nout` veces y regresa una matriz
cuya columna `i` tiene los últimos `nout` iterados del mapeo
para el valor del parámetro del mapeo `crange[i]`.

La función `f` debe ser definida de tal manera que `f(x0, c)`
tenga sentido.
"""
function diag_bifurc(f, nit, nout, crange)
    #xx = Vector{Float64}(nout)
    ff = Array{Float64}(undef, (nout, length(crange)))

    for ic in eachindex(crange)
        c = crange[ic]
        ciclosestables!(view(ff, :, ic), f, c, nit, nout)
        #ff[:,ic] = xx
    end

    return ff
end

#-
Qc(x,c) = x^2 + c

crange = 0.25:-1/2^10:-2.0

ff = diag_bifurc(Qc, 2000, 256, crange);
cc = ones(size(ff, 1)) * crange';

#-
#Lo siguiente cambia las matrices en vectores; ayuda un poco para los dibujos
ff = reshape(ff, size(ff, 1)*size(ff, 2));
cc = reshape(cc, size(ff));

#-
scatter(cc, ff, markersize=0.5, markerstrokestyle=:solid, 
    legend=false, title="Fig. 1")
plot!([-1.2,-1.5,-1.5,-1.2,-1.2], [-1.5,-1.5,-0.9,-0.9,-1.5], color=:black)
plot!([-2,0.5], [0.0,0.0], color=:red)
xaxis!("c")
yaxis!("x_infty")
savefig("diag_bif1.png")

#-
# (Insertamos la figura producida en el texto!)
#
# ![Fig 1](diag_bif1.png "Fig. 1")

#-
# Es muy claro de este diagrama, Fig. 1, que la dinámica se vuelve rica 
# e interesante a medida que uno disminuye el parámetro $c$ más allá 
# de -5/4.

#-
# A continuación haremos un aumento (zoom) de la región indicada.

#-
scatter(cc, ff, markersize=0.5, markerstrokestyle=:solid, 
    legend=false, title="Fig. 2")
xaxis!("c")
yaxis!("x_infty")
xlims!(-1.5,-1.2)
ylims!(-1.5,-0.9)
plot!([-1.35,-1.425,-1.425,-1.35,-1.35], [-1.425,-1.425,-1.33,-1.33,-1.425], color=:black)
savefig("diag_bif2.png")

#-
# ![Fig 2](diag_bif2.png "Fig. 2")

#-
# La Fig. 2 muestra el aumento indicado en la Fig. 1, usando los mismos puntos
# calculados que se usaron en la Fig. 1. Ahí se muestra 
# que después del reescalamiento se obtiene esencialmente la misma 
# estructura que la gráfica completa (Fig. 1). La curva suave de la 
# derecha corresponde en este caso a una de las ramas de periodo 2.

#-
# Claramente podemos ver que en $c=-5/4$ hay *otra* bifurcación de 
# doblamiento de periodo. A partir de ese valor, la órbita de periodo 2 
# se torna en un repulsor y aparece una órbita de periodo 4 atractiva.

#-
# Este escenario se preserva hasta cierto valor de $c$ donde la órbita 
# de periodo 4 se vuelve inestable (repulsiva), y aparece ahora un 
# ciclo de periodo 8, por doblamiento de periodo. De hecho, la figura 
# muestra que *antes* de $c\simeq -1.4$, aparece un ciclo estable de 
# periodo 16.

#-
# Claramente estamos observando *una cascada de bifurcaciones* de 
# doblamiento de periodo. Esto es, al disminuir $c$
# los puntos periódicos aparecen en el orden: $1, 2, 4, 8, \dots, 2^n, \dots$. Además, el intervalo en $c$ donde el periodo $2^n$ se observa, es mayor que donde se observa el periodo $2^{n+1}$.
# 
# Aumentos sucesivos muestran la veracidad de esto, aunque para 
# tener suficientes puntos hay que hacer nuevos cálculos. 
# En la Fig. 3, que corresponde al recuadro indicado en la Fig. 2, 
# la curva de la derecha corresponde a una de las ramas del ciclo de 
# periodo 4.

crange = -1.35:-1/2^13:-1.425

ff1 = diag_bifurc(Qc, 4000, 512, crange);
cc1 = ones(size(ff1, 1)) * crange';

#Esto cambia las matrices en vectores; ayuda un poco para los dibujos
ff1 = reshape(ff1, size(ff1, 1)*size(ff1, 2));
cc1 = reshape(cc1, size(ff1));

#-
scatter(cc1, ff1, markersize=0.5, markerstrokestyle=:solid, 
    legend=false, title="Fig. 3")
xaxis!("c")
yaxis!("x_infty")
xlims!(-1.425,-1.35)
ylims!(-1.425,-1.33)
savefig("diag_bif3.png")

#-
# ![Fig 3](diag_bif3.png "Fig. 3")

#-
# En estas figuras uno puede además observar ciertas regiones del 
# parámetro $c$ donde *aparecen* ventanas de baja periodicidad, pero 
# cuyo periodo **no** es de la forma $2^n$, y también se aprecia que 
# éstas van seguidas de otras casadas de bifurcaciones de doblamiento 
# de periodo. Un ejemplo notable es la ventana de *periodo 3* que se 
# muestra en la Fig. 1. Como veremos más adelante, la existencia del 
# periodo 3 implica caos.

#-
# La observación de que los intervalos en $c$ donde se observa 
# cierta periodicidad *disminuyen* al aumentar la periodicidad 
# (respetando el doblamiento de periodo), lleva a la pregunta si hay 
# una $c$ donde se observe un periodo *infinito*. 
# 
# Esto lo contestaremos en los siguientes ejercicios.
# 
