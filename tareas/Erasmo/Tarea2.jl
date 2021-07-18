
# # Tarea 2: Exponentes de Lyapunov y universalidad
# 
# > Fecha de envío: 2 de julio
# >
# > Fecha de aceptación: 30 de julio

using Pkg
Pkg.activate("..")
Pkg.instantiate()
using Plots, IntervalArithmetic, IntervalRootFinding, OffsetArrays
#-

"Mapeo cuadrático evaluado en `x`, con parámetro `c`"
Qc(x,c) = x^2 + c

Qc(x, args...) = Qc(x, args[1])

"""
    Qcⁿ(x, args)

Esta función regresa el n-enésimo iterado de ``Q_c(x,c)``,
donde el valor a iterar es `x` y el valor del parámetro
es `c`, donde `c = args[1]` y `n = args[2]`.
"""
function Qcⁿ(x, args)
    c, n = args[1], args[2]
    n <= 1 && return Qc(x,c)
    for it = 1:n
        x = Qc(x,c)
    end
    return x
end
#-

# ## Ejercicio 1:
# 
# Para la familia de mapeos cuadrática $Q_c(x) = x^2 + c$, generen el diagrama que
# muestra el exponente de Lyapunov en términos de $c$, para $c\in[-2,2]$.
# Utilizen un paso suficientemente fino (en $c$) para que el diagrama muestren
# la riqueza del comportamiento.
# 
# - ¿Qué particularidad ocurre (en términos del exponente de Lyapunov) para los valores de $c$ donde hay bifurcaciones?
# 
# - ¿Qué particularidad ocurre (en términos del exponente de Lyapunov) cuando tenemos *ciclos superestables*, es decir, cuando $x=0$ es parte de un ciclo periódico?

#Respuesta
#-

# ## Ejercicio 2:
# 
# Llamaremos $c_n$ al valor del parámetro $c$ donde ocurre el ciclo superestable
# de periodo $2^n$, esto es, el valor de $c$ donde $x_0=0$ pertenece a la órbita
# periódica de periodo $2^n$. Algunos de estos valores fueron obtenidos
# numéricamente en una de las notas de clase.
# (De manera alternativa, pueden considerar que $c_n$ es el valor del parámetro $c$
# donde ocurre la bifurcación de doblamiento de periodo para el mapeo $Q_c(x)=x^2+c$,
# es decir, donde la órbita de periodo $2^n$ nace. Como hemos visto en clase,
# tenemos que $c_0=1/4$ marca la aparición del atractor de periodo $2^0=1$,
# $c_1=-1/4$ corresponde a la aparición del atractor de periodo $2^1=2$ y
# $c_2=-3/4$ a la aparición del atractor de periodo $2^2=4$.)
# 
# - Calculen los valores de $c_r$ (al menos hasta $c_6$, pero traten
# de obtener aún más valores). Con estos valores, definimos la secuencia:
# $\{f_0, f_1, f_2, \dots\}$, donde
# \begin{equation}
# f_n = \frac{c_n-c_{n+1}}{c_{n+1}-c_{n+2}} .
# \end{equation}
# Aproximen el valor al que converge esta secuencia,
# es decir, dar una estimación de $\delta = f_\infty$.
# 
# - De los $2^p$ puntos del ciclo de periodo $2^p$, es decir,
# $\{0, p_1, \dots p_{2^{n-1}}\,\}$ hay uno (distinto del 0) cuya distancia
# a 0 es la menor; a esa distancia la identificaremos como $d_n$.
# Estimen numéricamente a qué converge la secuencia $\alpha = - d_n/d_{n+1}$ en
# el límite de $n$ muy grande.

# ## Solución:
# 
# Se sigue la estrategia de clase _41-Universalidad_ para calcular los $c_n$.
# Esto es, $c_n$ corresponde al valor de $c$ para el cual ocurre el ciclo
# superestable de periodo $2^n$. De esta forma, $c_n$ es solución a la ecuación
# de grado $2^n$ dada por
# 
# $$ Q_c^{2^n}(0) = 0 .$$
# 
# Sea $q^n(c) = Q_c^n(0)$, de tal forma que de tal forma que $c_n$ es una de las
# raíces de $q^{2^n}(c)$. Nótese que aquí cambió la definición del exponente
# ya que $q^{n+1}(c) \neq q^1(q^n(c))$.
# 
# A continuación se muestra una gráfica de $q^{2n}(c)$ con $n = 0, 1,...,6$.

n = 6
xrange = -2.:1/256:0.25
y = Array{Array{Float64,1}}(undef, n+1)
labels = Array{String, 1}(undef, n+1)

for i ∈ 0:n
    q = c->Qcⁿ(0.0, (c, 2^i))
    y[i+1] = q.(xrange)
    labels[i+1] = "n = $i"
end
#-

plot(xrange, y, xlabel = 'c', ylabel = "q^2n(c)", label = permutedims(labels),
    grid = false, framestyle = :origin, legend = :outertopright)
#-

# En la gráfica se observa que todas las funciones pasan por el origen.
# De hecho, nótese que 
# 
# $$ q^n(0) = Q_0^n(0) = x^{2n}|_{x=0} = 0, $$
# 
# es decir que $0$ es raíz de $q^n$ para cualquier $n \in \mathbb{N}.$
# 
# Además, la gráfica sugiere que todas las funciones tienen las mismas
# raíces. Esto se va a demostrar en el siguiente párrafo.
# 
# Sea $\alpha_n^*$ una raíz de $q^n$, es deicr, tal $q^n(\alpha_n^*) = 0$.
# Nótese que $\alpha_n^*$ también es raíz de $q^{2n}$:
# 
# $$ q^{2n}(\alpha_n^*) = Q_{\alpha_n^*}^{2n}(0) = Q_{\alpha_n^*}^n\big(Q_{\alpha_n^*}^n(0)\big) = Q_{\alpha_n^*}^n\big(q^n(\alpha_n^*)\big) = Q_{\alpha_n^*}^n(0) = q^n(\alpha_n^*) = 0, $$
# 
# por lo que toda raíz de $q^n$ es también raíz de $q^{2n}$ y esto es cierto
# para toda $n \in \mathbb{N}$. Esto quiere decir que una forma de calcular los
# $c_n$ es encontrando las raíces de un $q^{2^n}$ para una $n$ grande.
# 
# La propuesta anterior para calcular los $c_n$ es teóricamente
# sencilla. Sin embargo, como no se conoce el valor de $c_\infty$ y como la
# función $q^{2^n}$ tiene hasta $2^n$ raíces en el intervalo $[-2, 0.25]$,
# calcular sus raíces es muy costoso. Por esta razón se calculará
# $c_{n+1}$ encontrando la raíz más grande de $q^{2^{n+1}}$ tal que
# $c_{n+1} < c_n$. Las raíces se encontrarán usando `IntervalRootFinding.jl`.
# 
# Nótese que $c_0$ y $c_1$ se pueden calcular analíticamente
# 
# $$ q^1(c_0) = c_0 = 0 \quad \Rightarrow \quad c_0 = 0.$$
# $$ q^2(c_1) = c_1^2 + c_1 = c_1 (c_1 + 1) = 0 \quad \Rightarrow \quad c_1 = -1.$$
# 
# por lo que se parte de estos valores para calcular $c_n$ para $n>1$.

import Base: isless
import Polynomials: roots
#-

isless(r1::Root, r2::Root) = isless(r1.interval, r2.interval)
#-

"""
issameroot(r1::Root, r2::Root)

Returns true when the statuses of both r1 and r2 is :unique
and when their intervals aren't disjoint. That is, when
r1 and r2 represent the same root.
"""
function issameroot(r1::Root, r2::Root)
    !(isunique(r1) && isunique(r2)) && return false
    !isdisjoint(r1.interval, r2.interval)
end
#-

roots(f, X; contractor, strategy, tol) = roots(f, X, contractor, strategy, tol)
roots(f, X; contractor, tol) = roots(f, X, contractor, tol)
#-

"""
cₙ(f, cₙ₋₁::Root, n, interval; kwargs...)

Regresa el valor cₙ del parámetro c tal que
f tiene un ciclo superestable de periodo
2ⁿ.

Esto se hace calculando raíces en el
intervalo `interval`. Los `kwargs`
se pasan como argumentos a 
`IntervalRootFinding.root`.
"""
cₙ(f, cₙ₋₁::Root, n, interval; kwargs...) = maximum(filter(x->!issameroot(x, cₙ₋₁),
        roots(c->f(0.0, (c, 2^n)), interval; kwargs...) ))
#-

"""
intervalo(cₙ₋₂interval, cₙ₋₁interval)

Calcula el intervalo donde se buscará cn.
"""
function intervalo(cₙ₋₂interval, cₙ₋₁interval)
    d = cₙ₋₂interval.hi-cₙ₋₁interval.lo
    (cₙ₋₁interval.lo - 0.9d)..(cₙ₋₁interval.hi + 0.1d)
end

intervalo(cₙ₋₂::Root, cₙ₋₁::Root) = intervalo(cₙ₋₂.interval, cₙ₋₁.interval)
#-

cₙ(f, cₙ₋₂::Root, cₙ₋₁::Root, n; kwargs...) = cₙ(f, cₙ₋₁, n, intervalo(cₙ₋₂, cₙ₋₁); kwargs...)

function cₙ!(f, cns::AbstractVector, i, n; kwargs...)
    cns[i] = cₙ(f, cns[i-2], cns[i-1], n; kwargs...)
end

cₙ!(f, cns::AbstractVector, n; kwargs...) = cₙ!(f, cns, n, n; kwargs...)

function cₙ!(f, cns::AbstractVector, i, n₁, n₂; kwargs...)
    for (j, n) ∈ enumerate(n₁:n₂)
        cₙ!(f, cns, i+j-1, n; kwargs...)
    end
    return cns
end
#-

n = 11
rootcns = OffsetVector(Vector{Root{Interval{Float64}}}(undef, n+1), 0:n)
rootcns[0] = Root(0.0..0.0, :unique)
rootcns[1] = Root((-1)..(-1), :unique)

setformat(:midpoint)
cₙ!(Qcⁿ, rootcns, 2, 2, 11, contractor=Krawczyk, tol=1e-16)
#-

"""
fₙ!(fns, cns, i, j, m)

Calcula el valor fₙ para n de i a i+m
y los guarda en `fns`.

Argumentos:
    - fns    : arreglo donde se guardan los
valores de fₙ.
    - cns    : arreglo con los valores de cₙ.
    - i      : índice apartir del cual se
comienzan a sobre escribir los elementos de
`fns`.
    - j      : índice apartir del cual se
comienzan a leer los elementos de `cns`.
    - m      : número de veces que se
calcula fₙ.
"""
function fₙ!(fns, cns, i, j, m)
    d1 = cns[j] - cns[j+1]
    d2 = zero(d1)
                    
    for k ∈ 1:m
        d2 = cns[j+k] - cns[j+k+1]
        fns[i+k-1] = d1/d2
        d1 = d2
    end
    return fns
end

fₙ!(fns, cns) = fₙ!(fns, cns, firstindex(fns), firstindex(cns), length(fns))
#-

cns = OffsetVector(Vector{Interval{Float64}}(undef, n+1), 0:n)
@. cns = interval(rootcns)
fns = OffsetVector(Vector{Interval{Float64}}(undef, n-1), 0:n-2)
fₙ!(fns, cns)
#-

# ## $\delta$

println("c$n ≈ c∞ ≈ $(cns[n])")
println("f∞ = δ ≈ $(fns[n-2])")
#-

"""
cₙ(f, cₙ, n)

Calcula el valor de dₙ. Es decir, la
distancia mínima distinta de cero del
ciclo superestable de periodo 2ⁿ al punto
x = 0.

En este caso `f` es el mapeo y
`cₙ` es el valor del parámetro c para
el cual ocurre el periodo superestabl
de periodo 2ⁿ.
"""
function dₙ(f, cₙ, n)
    x = f(zero(cₙ), (cₙ, 1))
    d = abs(x)
    
    for i ∈ 1:2^n-2
        x = f(x, (cₙ, 1))
        abs(x) < d && (d = abs(x))
    end
    
    return d
end

function dₙ!(f, dns, cns, i, j, n₁, n₂)
    for (k, n) ∈ enumerate(n₁:n₂)
        dns[i+k-1] = dₙ(f, cns[j+k-1], n)
    end
    return dns
end

dₙ!(f, dns, cns) = dₙ!(f, dns, cns, firstindex(dns), firstindex(cns)+1, 1, length(dns))
#-

dns = Vector{Interval{Float64}}(undef, n)
dₙ!(Qcⁿ, dns, cns)
#-

"""
αₙ!(αns, dns, i, j, m)

Calcula el valor αₙ para n de i a i+m
y los guarda en `αns`.

Argumentos:
    - αns    : arreglo donde se guardan los
valores de αₙ.
    - dns    : arreglo con los valores de dₙ.
    - i      : índice apartir del cual se
comienzan a sobre escribir los elementos de
`dns`.
    - j      : índice apartir del cual se
comienzan a leer los elementos de `dns`.
    - m      : número de veces que se
calcula αₙ.
"""
function αₙ!(αns, dns, i, j, m)
    for k ∈ 0:m-1
        αns[i+k] = -dns[i+k]/dns[i+k+1]
    end
    return αns
end
αₙ!(αns, dns) = αₙ!(αns, dns, firstindex(αns), firstindex(dns), length(αns))
#-

αns = Vector{Interval{Float64}}(undef, n-1)
αₙ!(αns, dns)
#-

# ## $\alpha$

println("α ≈ $(αns[n-1])")
#-

# ## Ejercicio 3:
# 
# Repitan el cálculo de $\delta$ y $\alpha$ a partir de la secuencia definida
# por las $c_n$ para el mapeo $S_c(x) = c \sin(x)$.
# 
# - ¿Cómo se comparan los valores obtenidos para $\delta$ y $\alpha$ con los obtenidos
# para $f_n$?
# 
# - ¿Qué interpretación le pueden dar al resultado?

#Respuestas
#-
