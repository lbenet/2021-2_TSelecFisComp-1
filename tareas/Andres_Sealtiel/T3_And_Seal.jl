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

# # Temas Selectos de Física Computacional
# ## Tarea 3
# ### Andres Ramos A. - Sealtiel Pichardo J.
# ### Ejr. 1

using Plots
using LaTeXStrings

"""
    F(x)
Función que se define en los puntos x = [1, 5] tal que F(1)= 3, F(2) = 5, F(3) = 4, F(4) = 2,
F(5) = 1 y en lo demás F es lineal.
"""
function F(x)
    @assert 1 ≤ x ≤ 5   ### assert comprueba la condición a la izq
    if x ≤ 2
        return 2x + 1
    elseif x ≤ 3
        return -x + 7
    elseif x ≤ 4
        return -2x + 10
    elseif x ≤ 5
        return -x + 6
    end 
end

"""
    Fⁿ(x, n)
Función que calcula el ``n``-ésimo iterado de la función F(x) y lo evalua en ``x``.
"""
function Fⁿ(x, n)
    for i in 1:n
        x = F(x)
    end
    return x
end

xs = 1:5
plot(xs, Fⁿ.(xs, 5), title="Fig. F(x)", xlabel="x", ylabel=L"F^n(x)", label=L"F^5",   ### F^5
    legend=:bottom, c="red")
scatter!(1:5, Fⁿ.(1:5, 5), label=false, c="red")
plot!(xs, Fⁿ.(xs, 3), label=L"F^3", c="blue")   ### F^3
scatter!(1:5, Fⁿ.(1:5, 3), label=false, c="blue")
plot!(xs, Fⁿ.(xs, 1), label=L"F^1", c="green")   ### F^1
scatter!(1:5, Fⁿ.(1:5, 1), label=false, c="green")
plot!(xs, identity, line=(:dash, 2), c="black", alpha=0.5, label=false)   ### Identidad
savefig("funcionatrozos.png")

# ![Fig_1](funcionatrozos.png)

# De la Fig. 1 observamos que para el **5to** iterado, la órbita de la función es justamente de periodo 5 ya que los puntos $x =$ {$1, 2, 3, 4, 5$} coinciden todos con la identidad, *i.e.* se mapean en ellos mismos.
#
# Sabiendo que ser de periodo 1 implica que cualquier iteración subsecuente tendrá justamente ese mismo periodo en el determinado punto, entonces uno podría pensar que si tenemos que el $5to$ iterado es de periodo $5$, muy probablemente tres de esos puntos vendrían del $3er$ iterado de periodo $3$ (presumiblemente).
#
# Pero al graficar el **3er** iterado la órbita es tal que ningún punto se mapea sobre él mismo, *i.e.* no tiene ningún periodo (salvo por el heredado de $F^1(x)$, periodo 1).

# ## Ejr. 2

Q2(x) = x^2 -2

"""
    Qⁿ(x, n)
Función que calcula el ``n``-ésimo iterado del mapeo cuadrático Q2(x) = x^2 - 2, y lo evalua en
``x``.
"""
function Qⁿ(x, n)
    n == 1 && return Q2(x)
    x = Q2(x)
    for i in 2:n
        x = Q2(x)
    end
    return x
end

"""
    distribucion(x₀, n, nbins)
Función que calcula el valor del ``n``-ésimo iterado del mapeo cuadrático Q(x), evualuado en la
condición inicial ``x_0``. Mostrando el histograma de distribución con ``nbins`` bins.
"""
function distribucion(x₀, n, nbins)
    xs = [Qⁿ(x₀, i) for i in 2:n]
    histogram(xs, bins=nbins, title="Fig. 2", xlabel=L"Q^n(x)",
        ylabel="frecuencia", label="x_0 = $x₀", legend=:top)
end

distribucion(-1.3, 100_000, 300)
savefig("histo1.png")

# ![Fig_1](histo1.png)

distribucion(1.7, 100_000, 300)
savefig("histo2.png")

# ![Fig_1](histo2.png)

# Después de haber estado "jugando" un rato con la condición inicial $x_0$ nos dimos cuenta que esta distribución toma la forma que se ve en las Fig. 2, para el intervalo $[-2, 2]$. A excepción de los valores $x_0 =$ {$-2, -1, 0, 1, 2$}. Fuera del intervalo se pierde el histograma.
#
# Excluyendo tales valores mencionados, cualitativamente, el histograma que se mostrará no depende de la condición inicial, aunque hay que notar que no son literalmente idénticos para todos los diferentes valores $x_0$ que se le puedan dar dentro de lo establecido.
#
# Por lo que podemos concluir que para el valor de $c = -2$, los valores del mapeo cuadrático evaluado en $x_0 \in [-2, 2]$ (salvo los valores ya exluídos) está acotado dentro del mismo intervalo $[-2, 2]$.
#
# ### Ejr. 3
#
# Para encontrar $p_+$ (un punto fijo) resolvemos la ecuación $x^2 -2.2 = x$ obteniendo
#
# $$
# x = \frac{5 \pm 7\sqrt{5}}{10}
# $$
#
# Por lo que el intervalo a considerar es
#
# $$
# \left[-\frac{5 + 7\sqrt{5}}{10}, \frac{5 + 7\sqrt{5}}{10} \right]
# $$

Q3(x) = x^2 - 2.2

"""
mapeando(f, x₀, n, lim)

Dada una función ``f`` y una condición inicial ``x₀``, se itera ``n`` veces la función sobre sí
misma, empezando por ``f(x₀)``. Mapeando las iteraciones y su convergencia o divergencia.

El parámetro ``lim`` nos dará el cuadro dentro del cuál se visualizarán las cosas. 
"""
function mapeando(f, x₀, n, lim)
    itsx = zeros(2n); itsx[1] = x₀
    itsy = zeros(2n); itsy[1] = f(x₀)
    for i in 2:2:2n-1
        itsx[i] = itsy[i-1]
        itsy[i] = itsy[i-1] 
        itsx[i+1] = itsy[i]
        itsy[i+1] = f(itsx[i+1])
    end
    plot(itsx[1:end-1], itsy[1:end-1], xlim=(-lim, lim), ylim=(-lim, lim), line=:dash,
        legend=:bottomright, title="Fig. 3", xlabel="x", ylabel=L"Q^n(x)", label="x_0 = $x₀")
        ### Punteada
    scatter!([itsx[1]], [itsy[1]], c="yellow", label=false)   ### Punto inicial
    scatter!(itsx[2:end-2], itsy[2:end-2], label=false)   ### Puntos
    scatter!([itsx[end-1]], [itsy[end-1]], c="red", label=false)   ### Punto final
    plot!(-lim:0.1:lim, f.(-lim:0.1:lim), label=false)   ### Función
    plot!(-lim:lim, x->x, alpha=0.3, c="black", label=false)   ### Identidad
end

mapeando(Q3, 0.5+7*sqrt(5)/10, 30, 3)

mapeando(Q3, 0.5-7*sqrt(5)/10, 60, 3)

mapeando(Q3, -(0.5+7*sqrt(5)/10), 30, 3)

# Después de estar "jugando" con la condición inicial dentro del intervalo establecido, vemos que para todas las que intentamos llega un punto en el que el iterado "sale del interior de la parábola", y por ende, a partir de ahí cuantos más iterados se hagan (que de hecho no son muchos, alrededor de 15 y el valor ya se salió), el valor del iterado empezará a diverger (hacia $\infty$). Es esta la carazterización que se observa del valor asintótico, es *divergente*.
#
# Ahora, recordando un poco el trabajo expuesto en clase, vemos que al evaluar el punto fijo $p_+ = \left(5 + 7\sqrt{5}\right)/10$ en la derivada, $Q´(p_+) = 2p_+ \approx 8.26$ es $> 1$, por lo que el punto es inestable.
#
# Mientras que al evaluar el punto fijo $p_- = \left(5 - 7\sqrt{5}\right)/10$, encontramos que $|Q´(p_-)| = 2|p_-| \approx 4.26 > 1$.
#
# Siendo esa la regla general, se debe cumplir que $|Q_c´(p_\pm)| < 1$ para que el punto sea estable (atractivo) y el iterado no siga el comportamiento divergente, *i.e.* para que se converja a algún punto. 
#
# Por lo que ninguno de los puntos fijos es atractivo. Teniendo que todos los puntos que se evalúen en el intervalo se "irán" al $\infty$.
#
# Salvo por tres puntos, justamente los fijos $p_+$ y $p_-$ junto con el negativo de $p_+$. Ellos quedarán atrapados en ellos mismos, cosa que no se pudo mostrar cualitativamente aquí ya que *Julia* al truncar los valores $p_\pm$ llegará una iteración (grande comparada con el resto de los puntos) en la que el iterado también se "irá" al $\infty$, como se ve en las Fig. 3. Reiterando que esto es por el truncamiento que tienen tales puntos.
#
# Por esto, los subconjuntos que se piden al final son
#
# $$
# \left(-\frac{5 + 7\sqrt{5}}{10}, \frac{5 - 7\sqrt{5}}{10} \right)
# $$
#
# $$
# \left(\frac{5 - 7\sqrt{5}}{10}, \frac{5 + 7\sqrt{5}}{10} \right)
# $$
#
# ya que para estos conjuntos después de cierto número (no muy grande) de iteraciones, los valores del mapeo iterado divergen, *i.e.* no pertenecen a tales conjuntos (una vez alcanzada esa $n$ nunca más vuelven a caer dentro del conjunto) por lo que la intersección con ellos es vacía.
#
# ### Ejr. 4
#
# **P.D.** Si existe $n \in N$ *tq* $|z_n| > 2 \Rightarrow |z_{n+1}| > |z_n|$
#
# **Dem** Por inducción.
#
# Para $n = 1$. Supongamos que $|z_1| > 2$
#
# $$
# |z_2| = |c^2  + c| \geq |c^2| - |c| = |c|^2 - |c| = |c|(|c| - 1) = |z_1|(|c| - 1) = |z_1|(|z_1| - 1)
# $$
#
# y como
#
# $$
# |z_1| > 2 \Rightarrow |z_1| - 1 > 1 \Rightarrow |z_1|(|z_1| - 1) > |z_1|
# $$
#
# ***pt***
#
# $$
# |z_2| > |z_1|
# $$
#
# Para $n-1$. Supongamos que $|z_{n-1}| > 2 \Rightarrow |z_n| > |z_{n-1}|$.
#
# Para $n$. Suponiendo que $|z_{n}| > 2$, demostremos que $|z_{n+1}| > |z_n|$. Entonces
#
# $$
# |z_{n+1}| = |z_n^2 + c| \geq |z_n^2| - |c| = |z_n|^2 - |c| = |z_n|^2 - |z_1| > |z_n|
# $$
#
# Ya que (en este caso) se supone es la primer $n$ para la que se cumple que
#
# $$
# |z_{n}| > 2 \Rightarrow |z_1| < 2 \Rightarrow |z_1| < |z_n| \Rightarrow |z_1| < |z_n|^2
# $$
#
# $\therefore$  Si existe $n \in N$ *tq* $|z_n| > 2 \Rightarrow |z_{n+1}| > |z_n|$

using Images, ImageIO

"""
    numero_pasos(c::Complex{Float64}, n=200, pasos_max=30)
Función que para un número complejo ``c``, se calculan ``n`` iterados, pero buscando si cada
iterado cumple la desigualdad. En caso de hacerlo, se detiene y arroja el número de pasos ``n``
que necesitó la función. Si no cumple que el mínimo número de pasos establecido, regresa tal
número de pasos máximo.
"""
function numero_pasos(c::Complex{Float64}, n=300, pasos_max=30)
    z = 0 + 0im
    for i in 1:n
        z = z^2 + c
        if abs(z) > 2
            return i
        elseif i == pasos_max
            return pasos_max
        end
    end
    return 0
end

#= Construimos una matriz `Imagen` de rxr tal que cada entrada representa un pixel de color
negro, en el ciclo *for* "coloreamos" la matriz entrada a entrada (pixel a pixel), con la función
``numero_pasos``. Cuando el complejo z alcanza el número de pasos máximo ``pasos_max`` los
"pinta" según se acomoden en ``RGB(a,b,c)``.
=#
r = 8000   ### reescalamiento
Imagen = [RGB(0,0,0) for i in 1:r, j in 1:r]; pasos_max = 30   ### Matriz de "0's"
for i in 1:r   ### Ciclo que la rellena
    for j in 1:r
        Imagen[j,i] = RGB((numero_pasos((-2+4.0*i/r)+(2-4.0*j/r)im)/pasos_max),
            (numero_pasos((-2+4.0*i/r)+(2-4.0*j/r)im)/pasos_max), 0)
    end
end
Imagen
save("Mandel.png", Imagen)

# ![Mandel.png](attachment:Mandel.png)

# ### Ejr. 5

"""
    numero_pasos(c::Complex{Float64}, n)
Función que para un número complejo ``c``, se calculan ``n`` iterados, pero buscando si cada
iterado cumple la desigualdad. Devolviendo la ``n`` para la que se cumple la desigualdad.
"""
function numero_pasos_n(c::Complex{Float64}, n)
    z = 0.0 + 0.0im
    for i in 1:n
        z = z^2+c
        if abs(z) > 2
            return imag(c)*i
        end
    end
    return imag(c)*(n+1)
end

"""
    yes(n)
Esta función calcula las ``y``'s que se utilizarán en la función
`numero_pasos_n(c::Complex{Float64}, n)` para poder obtener la convergencia de ``P``.
"""
function yes(n)
    p = zeros(n)
    for i in 1:n
        p[i] = 1/(1.0*i)^4
    end
    return p
end

ys = yes(50)
[numero_pasos_n(-0.75+y*im, 100_000_000) for y in ys]

# Del "vector" obtenido arriba, podemos ver que
#
# $$
# lim_{y\rightarrow 0}P = lim_{y\rightarrow 0}yn(y) = \pi
# $$
