# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.11.4
#   kernelspec:
#     display_name: Julia 1.6.2
#     language: julia
#     name: julia-1.6
# ---

# <div style="text-align: center"> 
#
# # Temas Selectos de Física Computacional I
# ## Tarea 2
# #### Ramos Arzate Andres & Pichardo Jiménez, Sealtiel ####
#
# ### Ejercicio. 1    
# </div>

"""
    iterados(f, x₀, c, n)
Función que calcula los *'n'* iterados de la función *'f(x,c)'*, evaluada en la condición inicial
*'x₀'* y con constante *'c'*.
"""
function iterados(f, x₀, c, n)
    iters = zeros(n+1)
    iters[1] = f(x₀, c)
    for i in 1:n
        iters[i+1] = f(iters[i], c)
    end
    return iters
end

# ***Avisos***
#
# ***1*** *De aquí en adelante se verán varias funciones "silenciadas" (i.e. con un ``#`` al inicio para que no se ejecute el código de esa celda), como sub-funciones de las funciones principales que se ejecutan por individual (ya que se iban probando), así como aquellas que te muestran su documentación. Esto para hacer menos extenso y pesado el notebook de lo que ya es y no ser ejecuciones necesarias para los resultados.*
#
# ***2*** *Cuando se ejecuten las gráficas, estas ya tiene parámetros tanto de particion, tamaño de intervalo e iteraciones, tal que se buscó mas o menos estuvieran equilibrados entre dar buenos resultados y no tardarse tanto en ejecutar. Por lo que se recomienda al menos no la primera vez cambiar estos valores. Ya si después se quiere probar la funcionalidad con diferentes parámetros adelante, bajo la advertencia que algunas cosas sí que pueden tardar o inclusive trabar (mi compu murió un par de ocasiones :/ ).*

Q(x,c) = x^2 + c-2x^2

# +
#iterados(Q, 0, -3/2, 100_000_000)

# +
#?iterados
# -

"""
    suma_logs(f, x₀, c, n)
Función que da la suma de *'n'* logaritmos cuyos argumentos son respectivamente cada uno de los
*'n'* iterados de la función *'f'*, evualada en la condición inicial *'x₀'* y con constante
*'c'*. Tal suma dividida entre *'n'*.
"""
function suma_logs(f, x₀, c, n)
    args = iterados(f, x₀, c, n)
    suma = log(abs(2args[1]))
    for s in 2:n
        suma = suma + log(abs(2args[s]))
    end
    return suma/n
end

# +
#suma_logs(Q, 0, -3/2, 100_000_000)

# +
#?suma_logs
# -

"""
    exponentes_Liapunov(f, x₀, crange, n)
Función que calcula los exponentes de Liapunov del mapeo *'f'* evaluado en la condición
inicial *'x₀'*, para cada una de las constantes *'c'* elementos del arreglo *'crange'*. Esto con
*'n'* iteraciones de la función *'f'*.

Devolviendo un arreglo (matriz) de n x 2 cuya primer columna corresponde a las constantes *'c'*
y la segunda columna los respectivos exponentes de Liapunov.
"""
function exponentes_Liapunov(f, x₀, crange, n)
    CoefsCs = zeros(length(crange),2)
    for c in 1:length(crange)
        CoefsCs[c,1] = crange[c]
        CoefsCs[c,2] = suma_logs(f, x₀, crange[c], n)
    end
    return CoefsCs
end

# +
#exponentes_Liapunov(Q, 0, -2:1/1_000:2, 100_000)

# +
#?exponentes_Liapunov
# -

using Plots

"""
    grafica_eL(f, x₀, crange, n)
Función que grafica los exponentes de Liapunov de la función *'f'* evaluada en la condición
inicial *'x₀'* para cada una de las constantes *'c'* elementos del arreglo *'crange'*. Esto con
*'n'* iteraciones de la función *'f'*.
"""
function grafica_eL(f, x₀, crange, n)
    pts = exponentes_Liapunov(f, x₀, crange, n)
    plot(pts[:,1], pts[:,2], title="Exponentes de Liapunov", xaxis="'c'",
        yaxis="valor del e. L.", label="x₀ = $x₀", legend=:bottomleft)
end

# +
#?grafica_eL
# -

# *Nota: A partir de aquí empiezan las gráficas. Todas las funciones del tipo ``grafica_eL(f, x₀, crange, n)`` se han "silenciado" para que al recargar el notebook este no tarde mucho debido a la gran cantidad que hay de ellas. Y así, mientras se va revisando, se vaya ejecutando una a una y se tarde menos o evitar se pueda trabar.*

grafica_eL(Q, 0, -2:1/10_00:2, 100_000)


# Notamos que para aquellos valores de $c$ en donde hay bifurcaciones en el *'diagrama de bifurcaciones'*, aquí corresponden a los exponentes de Liapunov tal que surgen "picos" cóncavos en la gráfica, *i.e.* son "máximos locales" en cuanto al valor del exponente de Liapunov se refiere.
#
# Mientras que en aquellos puntos en donde se tienen ciclos superestables. como $x = 0$, lo que observamos es que los exponentes de Liapunov en principio ahora son "picos" convexos, *i.e.* "mínimos locales" en cuanto al valor del exponente de Liapunov se refiere.
#
# Pero, después de algo de discusión, considerando que tenemos sumas de logartimos cuyos argumentos son los n-ésimos iterados del mapeo (evaluados en $x = 0$), pensamos que más bien esos valores del *'exponente de Liapunov'* divergen porque varios de los argumentos de tales logaritmos tienden a, o son 0, por tanto el valor de esos logaritmos tiende a -$\infty$.
#
# Esto no se observa en nuestros mapeos porque la definición de los coeficientes de Liapunov es  estrictamente un límite cuando el número de iteraciones tiende a $\infty$ (aquí estamos usando la definición para mapeos suaves como es el cuadrático), algo no realizable ni graficable por una computadora.
#
# *Nota: Después de probar diferentes valores, se llegó a la conclusión de que 100'000 iteraciones es buena aproximación. Si se incrementara a 1'000'000 (como se hizo), cualitativamente hablando no se observan cambios en la gráfica, pero sí aumenta mucho el tiempo de ejecución. Por eso nos quedamos con 100'000.*
#
# <div style="text-align: center"> 
#     
# ### Ejercicio. 2    
# </div>
#
# De la gráfica *'Exponentes de Liapunov'* obtenida en el Ejr. 1, podemos ver cualitativamente que $c_0 = 1/4$ y $c_1 = -3/4$, considerando el caso en el que para el valor de la constante $c$ surgen bifurcaciones o doblamiento de periodo.
#
# Entonces, basándonos en la pequeña discusión hecha arriba, la manera de obtener los siguientes *c$_n$* será utilizando el arreglo de los exponentes de Liapunov obtenidos con la función ``exponentes_Liapunov(f, x₀, crange, n)``.
#
# Hacemos un "zoom" para tener una mejor apreciación de más o menos por dónde andan los siguientes *c$_n$*.

# +
#grafica_eL(Q, 0, -2:1/10_000:1/4, 100_000)
# -

# En principio $c_2$ se observa relativamente fácil. Hacemos otro "zoom".

# +
#grafica_eL(Q, 0, -1.4:1/10_000: -1.2, 100_000)
# -

"""
    buscador_cs(f, x₀, crange, n)
Función que dada la función (mapeo) *'f'*, evaluada en la condición inicial *'x₀'*, un intervalo
de valores constantes *'c'* para la función *'f'* del cual ya viene determinada su partición y
el número de iteraciones a considerar *'n'*, devuelve los coeficientes *'c_n'* en tal intervalo.
"""
function buscador_cs(f, x₀, crange, n)
    arr = exponentes_Liapunov(f, x₀, crange, n); arr2 = reverse(arr)
    iter = length(arr2[:,1]); cns = []
    for i in 3:iter
        if (arr2[i,1] < arr2[i-1,1]) && (arr2[i-1,1] > arr2[i-2,1])
            push!(cns,arr2[i-1,2])
        end
    end
    return cns
end

# +
#?buscador_cs

# +
#grafica_eL(Q, 0, -1.250005:1/1_000_000: -1.249990, 100_000)
# -

# Del mapeo anterior (después de estar tanteando un poco), llegamos a que para obtener el siguiente $c_n$ es conveniente fijarse alrededor del intervalo *[-1.255, -1.245]*.

buscador_cs(Q, 0, -1.250005:1/1_000_000_000: -1.249990, 100_000)

# Hemos obtenido $c_2$, con un intervalo muy chico y una partición muy fina. Pero después de hacer los cálculos, consideramos que este valor es -1.25 ciertamente.

c2 = -1.25

# Procediendo de manera análoga, partiendo del extremo izquierdo del intervalo anterior ahora como extremo derecho del próximo intervalo a considerar, vamos tanteando de ambos extremos.
#
# Encontramos ahora que un buen intervalo a considerar es *[-1.368097, -1.368096]*

# +
#grafica_eL(Q, 0, -1.368097:1/10_000_000: -1.368096, 100_000)
# -

c3 = buscador_cs(Q, 0, -1.368097:1/10_000_000_000: -1.368096, 100_000)

# Hemos encontrado $c_3$.
#
# Podemos seguir haciendo esto para encontrar cuantos $c_n$ queramos, pero puede llegar a ser algo lento y tedioso.
#
# De otra manera, pudiéramos aplicar la función ``buscador_cs(f, x₀, crange, n)`` a un intervalo mayor y en teoría debería encontrar todas las $c_n$ del intervalo, pero pensamos surgen dos complicaciones.
#
# Primero, un intervalo más grande implica que dependiendo la partición, puede llegar a tomar bastante tiempo de ejecución. 
#
# Y segundo, lo anterior podría ser compensado haciendo una partición menor, pero después de varias pruebas de particiones menores (con intervalos grandes, por decir *[-2, 2]*), si bien hacen que el tiempo de ejecución sea más rápido, esto da lugar a menor precisión de los valores $c_n$ que se encuentren, y peor aún, se ha observado pueden haber $c_n$ que se pierdan por tener particiones menos finas.
#
# Aprovechando un poco el requerimiento mínimo de encontrar hasta $c_6$ al menos, hemos procedido así. Omitiendo ya los detalles de los tanteos.
#
# Obteniendo así $c_4$, $c_5$, $c_6$, $c_7$ y $c_8$.

c4 = buscador_cs(Q, 0, -1.3940465:1/10_000_000_000: -1.3940445, 100_000)

c5 = buscador_cs(Q, 0, -1.3996310:1/10_000_000_000: -1.3996305, 100_000)

c6 = buscador_cs(Q, 0, -1.400829:1/10_000_000_000: -1.400828, 100_000)

c7 = buscador_cs(Q, 0, -1.4010855:1/10_000_000_000: -1.4010850, 100_000)

c8 = buscador_cs(Q, 0, -1.401141:1/10_000_000_000: -1.401139, 100_000) 

# Continuando, para calcular la secuencia {$f_i$}, unimos los arreglos encontrados por separado, pero también antes definiendo "a mano" el primero.
#
# Imponemos el mismo número de decimales para todos los elementos. Esto porque como se observa, de vez en cuando se obtiene un valor que sobresale en número decimales y aparte todos son $0$ salvo el último decimal, y esto puede hacer que las $f_i$ se alejen mucho de la tendencia.

c01 = [0.25,-0.75]

cns = [c01; c2; c3; c4; c5; c6; c7; c8]

cnsb = round.(cns, digits=10)

"""
    secuencia_f_plot(v, cuchareo, cuchareo2)
Función que dado un arreglo *'v'* calcula las *f_i* de la secuencia {*f_n*}.

Los párametros para "cucharear" lo que hacen es teniendo el arreglo que calcula la función,
podemos decidir desde qué elemento a qué elemento del arreglo queremos graficar.
"""
function secuencia_f_plot(v, cuchareo, cuchareo2)
    n = length(v); fs = zeros(n); c = cuchareo; c2 = cuchareo2
    for i in 1:n-3
        fs[i] = (v[i+1] - v[i])/(v[i+2] - v[i+1])
    end
    plot([c-1:c2-1],fs[c:c2], title="{f_i}", xaxis="n", yaxis="f_n", xlims=(c-2,c2))
    scatter!([c-1:c2-1],fs[c:c2], legend=false)
end

# +
#?secuencia_f_plot
# -

"""
    secuencia_f(v, cuchareo, cuchareo2)
Función que dado un arreglo *'v'* calcula las *f_i* de la secuencia {*f_n*}.

Los párametros para "cucharear" lo que hacen es teniendo el arreglo que calcula la función,
podemos decidir desde qué elemento a qué elemento del arreglo devuelva la función.
"""
function secuencia_f(v, cuchareo, cuchareo2)
    n = length(v); fs = zeros(n); c = cuchareo; c2 = cuchareo2
    for i in 1:n-3
        fs[i] = (v[i+1] - v[i])/(v[i+2] - v[i+1])
    end
    return fs[c:c2]
end

# +
#?secuencia_f
# -

# Aprovechando que los valores de $\delta$ y $\alpha$ están aproximados teóricamente, al buscarlos (se denominan *Números de Feigenbaum*) encontramos que
#
# $\delta \approx 4.669'201'609'102'990'671'853'203'821'578'439'... $
#
# $\alpha\approx 2.502'907'875'095'892'822'283'902'873'218'478'... $
#
# Si bien los primeros valores $c_n$ que obtenemos son buenos, al no ser muchos más $c_n$ (infinitos de hecho), las diferencias en el numerador y denominador de la definición de $f_i$
#
# $$ f_n = \frac{c_{n+1} - c_n}{c_{n+2} - c_{n+1}} $$
#
# pueden no ser muy buenos resultados, haciendo que tal cociente caiga a $0$.
#
# Graficamos para observar la posible tendencia y lo último dicho.

secuencia_f_plot(cnsb, 1, 9)

# Por lo que para obtener delta, se había definido esta función que obtiene el promedio de los mejores valores obtenidos $f_i$ en la secuencia.

"""
    delta(v,c,c2)
Función que devuelve el valor *delta* de un arreglo *'v'* para el intervalo *[c, c2]* más
conveniente.
"""
function delta(v,c,c2)
    d = v[c:c2]; n = length(d); a = 0
    for i in 1:n
        a = a + d[i]
    end
    return a/n
end

fs = secuencia_f(cnsb, 1, 9)

delta(fs, 2, 6)

# Pero por indicación del profesor, in hacer promedio, nos quedamos con el valor de $f_i$ para la mayor $_i$ tal que su valor se aproxime mejor a $\delta$.

fs[6]

# En ambos casos obtenemos una buena aproximación de $\delta$ considerando que se han hecho pocos $c_n$ cuando por definición estrictamente deberían ser infinitos.
#
# Por último, para obtener $\alpha$ usaremos un poco el trabajo hecho en la clase *Universalidad*. De hecho sólo para las gráficas, las raíces las obtendremos haciendo un "truco" con nuestra función buscador ``buscador_cs(f, x₀, crange, n)``. Y es que la modificamos para que en ver de buscar máximos, busque mínimos en el intervalo.

function Qⁿ(x, c, n)
    n ≤ 1 && return Q(x,c)
    for i in 1:n
        x = Q(x,c)
    end
    return x
end

"""
    buscador_rs(f, x₀, crange, n)
Función que dada la función (mapeo) *'f'*, evaluada en la condición inicial *'x₀'*, un intervalo
de valores constantes *'c'* para la función *'f'* del cual ya viene determinada su partición y
el número de iteraciones a considerar *'n'*, devuelve las raíces *'r_n'* en tal intervalo.
"""
function buscador_rs(f, x₀, crange, n)
    arr = exponentes_Liapunov(f, x₀, crange, n); arr2 = reverse(arr)
    iter = length(arr2[:,1]); rs = 0
    for i in 3:iter
        if (arr2[i,1] ≥ arr2[i-1,1]) && (arr2[i-1,1] ≤ arr2[i-2,1])
            rs = arr2[i-1,2]
        end
    end
    return rs
end

# +
#grafica_eL(Q, 0, -1.50:1/100_000: -1.25, 100_000)
# -

r0 = 0
r1= -1.0;

r2 = buscador_rs(Q, 0, -1.3107030:1/100_000_000: -1.3107020, 100_000)

r3 = buscador_rs(Q, 0, -1.3815480:1/100_000_000: -1.3815470, 100_000)

xs = -1:1/100:1
plot(xs, x->Qⁿ(x, r3, 8), legend=false)
plot!(xs, x->x)
scatter!([0],[0])

r4 = buscador_rs(Q, 0, -1.3969460:1/100_000_000: -1.3969450, 100_000)

# +
#grafica_eL(Q, 0, -1.3969460:1/100_000_000: -1.3969450, 100_000)
# -

xs2 = -1:1/1000:1
plot(xs2, x->Qⁿ(x, r4, 16), legend=false)
plot!(xs2, x->x)
scatter!([0],[0])

"""
    ds(xs, r, ite, eps)
Función que dado un intervalo de equis *[0,x] 'xs'*, la n-ésima raíz*'r'* correspondiente a la
iteración 2ⁿ del mapeo cuadrático *Q(x,c) = x² + c*, encuentra e imprime el primer punto de la
gráfica que intersecta con la identidad (omitiendo el *0* obviamente) bajo la condición de que su
diferencia con la identidad es menor al parámetro épsilon *'eps'*.

Devolviendo la distancia euclideana de este punto con el origen.
"""
function ds(xs, r, ite, eps)
    l = length(xs); pts = zeros(l)
    for i in 2:l
        der = Qⁿ(xs[i], r, ite); izq = Qⁿ(-xs[i], r, ite)
        if abs(der - xs[i]) < eps
            println(xs[i])
            return sqrt(2)*xs[i]
        elseif abs(izq + xs[i]) < eps
            println(-xs[i])
            return sqrt(2)*xs[i]
        end
    end
end

# +
#?ds
# -

dsnum = ds(0:1/10_000:0.2, r3, 8, 1e-5)

dsden = ds(0:1/1_000_000:0.1, r4, 16, 1e-7)

alpa = dsnum/dsden

# Se obtiene un buen valor aproximado de $\alpha$ considerando que hacemos pocas iteraciones.

# <div style="text-align: center"> 
#
# ### Ejercicio. 3   
# </div>
#
# En principio, este ejr. se resolvería facilmente al aplicar las funciones ya hechas al nuevo mapeo $S(x,c) = csin(x)$. Pero rapidamente nos dimos cuenta que la manera en que hicimos varias funciones (ciertamente la que calcula la suma de logs), son particularmente para el mapeo cuadrático $Q(x,c) = x^2 + c$.
#
# Resolver esto costó un poco más de trabajo. Volver a definir las funciones necesarias pero ahora para el mapeo $S$. Copiar y pegar y modificar algunas cosas. Así, si se requiriera hacer esto para otras 2 o 3 funciones más diferentes, probablemente no costaría ya mucho trabajo. Pero si se quisiera usar esto para una cantidad considerable de funciones diferentes, entonces sí que pudiera ser más pesado y tedioso hacerlo.
#
# Para esta tarea en particular fue casi nada ya. Para mejorar este trabajo, el siguiente paso sería tratar de generalizar todas las funciones.
#
# Y en este caso, el punto para el cual la derivada se anula, para cualquier valor de $c$ resulta ser $\frac{\pi}{2}$, *i.e.* $S´(\frac{\pi}{2},c) = 0$. Por eso se utiliza este punto como punto de partida.

S(x,c) = c*sin(x)

"""
    suma_logs2(f, x₀, c, n)
Función que da la suma de *'n'* logaritmos cuyos argumentos son respectivamente cada uno de los
*'n'* iterados de la función *'f'*, evualada en la condición inicial *'x₀'* y con constante
*'c'*. Tal suma dividida entre *'n'*.
"""
function suma_logs2(f, x₀, c, n)
    args = iterados(f, x₀, c, n)
    suma = log(abs(cos(args[1])))
    for s in 2:n
        suma = suma + log(abs(cos(args[s])))
    end
    return suma/n
end

"""
    exponentes_Liapunov2(f, x₀, crange, n)
Función que calcula los exponentes de Liapunov del mapeo *'f'* evaluado en la condición
inicial *'x₀'*, para cada una de las constantes *'c'* elementos del arreglo *'crange'*. Esto con
*'n'* iteraciones de la función *'f'*.

Devolviendo un arreglo (matriz) de n x 2 cuya primer columna corresponde a las constantes *'c'*
y la segunda columna los respectivos exponentes de Liapunov.
"""
function exponentes_Liapunov2(f, x₀, crange, n)
    CoefsCs = zeros(length(crange),2)
    for c in 1:length(crange)
        CoefsCs[c,1] = crange[c]
        CoefsCs[c,2] = suma_logs2(f, x₀, crange[c], n)
    end
    return CoefsCs
end

"""
    grafica_eL2(f, x₀, crange, n)
Función que grafica los exponentes de Liapunov de la función *'f'* evaluada en la condición
inicial *'x₀'* para cada una de las constantes *'c'* elementos del arreglo *'crange'*. Esto con
*'n'* iteraciones de la función *'f'*.
"""
function grafica_eL2(f, x₀, crange, n)
    pts = exponentes_Liapunov2(f, x₀, crange, n)
    plot(pts[:,1], pts[:,2], title="Exponentes de Liapunov", xaxis="'c'",
        yaxis="valor del e. L.", label="x₀ = $x₀", legend=:bottomleft)
end

"""
    buscador_cs2(f, x₀, crange, n)
Función que dada la función (mapeo) *'f'*, evaluada en la condición inicial *'x₀'*, un intervalo
de valores constantes *'c'* para la función *'f'* del cual ya viene determinada su partición y
el número de iteraciones a considerar *'n'*, devuelve los coeficientes *'c_n'* en tal intervalo.
"""
function buscador_cs2(f, x₀, crange, n)
    arr = exponentes_Liapunov2(f, x₀, crange, n)
    iter = length(arr[:,1]); cns = []
    for i in 3:iter
        if (arr[i,2] < arr[i-1,2]) && (arr[i-1,2] > arr[i-2,2])
            push!(cns,arr[i-1,1])
        end
    end
    return cns
end

# Debido a la periodicidad de $S$ buscamos en principio un intervalo adecuado. De ahí en fuera, se procedió análogamente que el Ejr. 2.

grafica_eL2(S, π/2, 1:1/10_00:π, 100_000)

c30 = buscador_cs2(S, π/2, 2.261805:1/1_000_000_000:2.261815, 100_000)

c31 = buscador_cs2(S, π/2, 2.617775:1/1_000_000_000:2.617785, 100_000)

c32 = buscador_cs2(S, π/2, 2.697395:1/1_000_000_000:2.697405, 100_000)

c33 = buscador_cs2(S, π/2, 2.7145990:1/1_000_000_000:2.7146005, 100_000)

c34 = buscador_cs2(S, π/2, 2.7182900:1/2_000_000_000:2.7182915, 100_000)

c35 = buscador_cs2(S, π/2, 2.719080:1/2_000_000_000:2.719085, 100_000)

c36 = buscador_cs2(S, π/2, 2.7192510:1/2_000_000_000:2.7192515, 100_000)

c37 = buscador_cs2(S, π/2, 2.71928750 : 1/2_000_000_000: 2.71928760, 100_000)

c38 = buscador_cs2(S, π/2, 2.7192950:1/2_000_000_000:2.7192955, 100_000)

cns3 = [c30; c31; c32; c33; c34; c35; c36; c37; c38]

secuencia_f_plot(cns3,1,9)

fs3 = secuencia_f(cns3,1,9)

delta(fs3,1,6)

fs3[6]

function Sⁿ(x, c, n)
    n ≤ 1 && return S(x,c)
    for i in 1:n
        x = S(x,c)
    end
    return x
end

"""
    buscador_rs2(f, x₀, crange, n)
Función que dada la función (mapeo) *'f'*, evaluada en la condición inicial *'x₀'*, un intervalo
de valores constantes *'c'* para la función *'f'* del cual ya viene determinada su partición y
el número de iteraciones a considerar *'n'*, devuelve las raíces *'r_n'* en tal intervalo.
"""
function buscador_rs2(f, x₀, crange, n)
    arr = exponentes_Liapunov2(f, x₀, crange, n)
    iter = length(arr[:,1]); rs = 0
    for i in 3:iter
        if (arr[i,2] ≥ arr[i-1,2]) && (arr[i-1,2] ≤ arr[i-2,2])
            rs = arr[i-1,1]
        end
    end
    return rs
end

r30=π/2;

r31 = buscador_rs2(S, π/2, 2.4433220:1/100_000_000:2.4433230, 100_000)

r32 = buscador_rs2(S, π/2, 2.6589878:1/100_000_000:2.6589882, 100_000)

r33 = buscador_rs2(S, π/2, 2.70632608:1/1_000_000_000:2.70632610, 100_000)

xs3 = 0:1/1_000:π
plot(xs3, x->Sⁿ(x, r33, 8), legend=false)
plot!(xs3, x->x)
scatter!([π/2], [π/2])

r34 = buscador_rs2(S, π/2, 2.7165166:1/1_000_000_000:2.7165170, 100_000)

xs4 = 0:1/1_000:π
plot(xs4, x->Sⁿ(x, r34, 16), legend=false)
plot!(xs4, x->x)
scatter!([π/2], [π/2])

# +
#grafica_eL2(S, π/2, 2.7165166:1/1_000_000_00:2.7165170, 100_000)
# -

# Debido a la particularidad de que la distancia que buscamo del primer "corte" ya no es al origen, sino a $(\frac{\pi}{2},\frac{\pi}{2})$, nos vimos en la necesidad de distinguir y especializar un poco los casos.

"""
    dsder(xs, r, ite, eps)
Función que dado un intervalo de equis *[x₁,x₂] 'xs'*, la n-ésima raíz*'r'* correspondiente a la
iteración 2ⁿ del mapeo trigonométrico *S(x,c) = csin(x)*, encuentra e imprime el primer punto de
la gráfica que intersecta con la identidad (omitiendo *π/2* obviamente) bajo la condición de que
su diferencia con la identidad es menor al parámetro épsilon *'eps'*.

Devolviendo la distancia euclideana de este punto con el origen.

Esto cuando se sabe de la gráfica que ese primer corte está a la derecha de π/2.
"""
function dsder(xs, r, ite, eps)
    l = length(xs); pts = zeros(l)
    for i in 2:l
        der = Sⁿ(xs[i], r, ite)
        if abs(der - xs[i]) < eps
            println(xs[i])
            return sqrt(2)*(xs[i] - π/2)
        end
    end
end

"""
    dsizq(xs, r, ite, eps)
Función que dado un intervalo de equis *[x₁,x₂] 'xs'*, la n-ésima raíz*'r'* correspondiente a la
iteración 2ⁿ del mapeo trigonométrico *S(x,c) = csin(x)*, encuentra e imprime el primer punto de
la gráfica que intersecta con la identidad (omitiendo *π/2* obviamente) bajo la condición de que
su diferencia con la identidad es menor al parámetro épsilon *'eps'*.

Devolviendo la distancia euclideana de este punto con el origen.

Esto cuando se sabe de la gráfica que ese primer corte está a la izquierda de π/2.
"""
function dsizq(xs, r, ite, eps)
    l = length(xs); pts = zeros(l)
    for i in 2:l
        izq = Sⁿ(xs[i], r, ite)
        if abs(izq - xs[i]) < eps
            println(xs[i])
            return sqrt(2)*(π/2 - xs[i])
        end
    end
end

d3num = dsder(1.62:1/100_000_000:1.68, r33, 8, 1e-5)

d3den = dsizq(1.53:1/100_000_000:1.56, r34, 16, 1e-5)

alpa3 = d3num/d3den

# Notamos que la universalidad se cumple ya que los valores $\delta$ y $\alpha$ son los mismo independientemente del mapeo, claro ambos son cuadráticos pero estos mapeos diferentes entre si.
#
# En nuestro segundo problema obtuvimos $$\delta= 4.667194395139248\hspace{0.5cm}y\hspace{0.5cm} \alpha= 2.5002497752023176$$
#
# y en este último
# $$\delta= 4.666919146685307\hspace{0.5cm}y\hspace{0.5cm} \alpha= 2.5045271677518994$$
#
# podemos apreciar que no son completamente iguales, esto se debe a que nuestra n aún no es lo suficentemente grande, pero ya nos muestra una igualdad al menos hasta centésimas.


