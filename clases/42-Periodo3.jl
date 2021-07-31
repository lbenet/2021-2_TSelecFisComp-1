# # Periodo 3

#-
# En el diagrama de bifurcaciones de la familia de mapeos cuadrática, y relacionándola
# en particular con el comportamiento del exponente de Lyapunov, podemos
# observar que después de la serie de bifurcaciones de doblamiento de periodo
# llegamos al caos, en el sentido de tener exponentes de Lyapunov positivos.
# Mas allá de esta región, podemos también observar en el diagrama de bifurcaciones
# que hay, eventualmente, un intervalo del parámetro $c$ que muestra una
# ventana de periodo 3.

#-
# En este notebook estudiaremos la dinámica cerca de la ventana de periodo 3.
# Usaremos funciones que escribimos en notebooks anteriores primero, para
# localizar la ventana de periodo 3, y después para hacer el análisis gráfico
# de la dinámica.

# ## Periodo 3 e intermitencia

#-
# Empezaremos aquí por localizar la ventana de periodo 3 en el diagrama de
# bifurcaciones. Para esto, usaremos las funciones `ciclosestables` y `diag_bifurc`
# que definimos en el notebook
# [`32_Bifurcaciones.jl`](https://github.com/lbenet/2021-2_TSelecFisComp-1/blob/main/clases/32_Bifurcaciones.jl).

#-
using Pkg
Pkg.activate("..")

using Plots

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
#Definimos el mapeo cuadrático
Qc(x,c) = x^2 + c

#Tercer iterado de Qc
Qc3(x,c) = Qc(Qc(Qc(x,c),c),c)

#-
# Empezamos con el diagrama de bifurcaciones considerance $c\in[-2,0.25]$, para localizar
# aproximadamente la ventana de periodo 3.

#-
# ![Diagrama bifurcacione](diag_bif1.png)

#-
# Del diagrama de bifurcaciones podemos ver que la ventana de periodo 3
# se encuentra en el intervalo $c\in [-1.8, -1.7]$. Verificamos esto.

#-
#Intervalo de interés para el diagrama de bifurcaciones
crange = -1.7:-1/2^12:-1.8
ff = diag_bifurc(Qc, 1000, 1000, crange);
cc = ones(size(ff, 1)) * crange';

#Cambiamos las matrices en vectores; útil para graficar
ff = reshape(ff, size(ff, 1)*size(ff, 2));
cc = reshape(cc, size(ff));

#-
scatter(cc, ff, markersize=0.5, markerstrokestyle=:solid,
    legend=false, title="Ventana de periodo 3")
xaxis!("c")
yaxis!("x_infty")
savefig("diag_bif_per3.png")

#-
# ![Diag. bifurcaciones cerca del periodo 3](diag_bif_per3.png)

#-
# Del diagrama anterior vemos que la ventana de periodo 3 inicia
# en $c=-1.75$. Otra cosa interesante a notar es que, la órbita de periodo 3
# eventualmente tiene una bifurcación de doblamiento de periodo, y genera una
# secuencia de doblamientos de periodo que nuevamente llevan al caos.

#-
# Consideraremos entonces los valores
# $c_+ = -1.75 + 1/2^{12}$ y $c_- = -1.75 - 1/2^{12}$, y analizaremos el
# comportamiento de $Q_c(x)$ con la función `itera_mapeo`. Como
# condición inicial usaremos el punto
# $x_0=1.0$, aunque cualquier otro (excepto un conjunto de medida cero)
# es igual de bueno. Para esto utilizaremos la función `itera_mapeo`
# codificada anteriormente.

#-
#Valores del parámetro cercanos a la bifurcación
c₊ = -1.75 + 1/2^12
c₋ = -1.75 - 1/2^12
c₊, c₋

#-
#Tomado de `31_Bifurcaciones.jl`
"""
    itera_mapeo(f, x0, n)

Itera la función ``x->f(x)``, de una dimensión, `n` veces a partir de la
condición inicial `x0`. Regresa dos vectores que se pueden usar para el
análisis gráfico.
"""
function itera_mapeo(f, x0, n::Int)
    #Defino/creo tres vectores de salida (de `Float64`s)
    its_x = [x0]
    its_y = [0.0]
    #Obtengo los iterados
    for i=1:n
        x1 = f(x0)
        push!(its_x, x0, x1)
        push!(its_y, x1, x1)
        x0 = x1
    end
    return its_x, its_y
end

#-
#Generamos los iterados del mapeo
x1, _ = itera_mapeo(x->Qc(x,c₊), 1.0, 400);
x2, _ = itera_mapeo(x->Qc(x,c₋), 1.0, 400);

#-
plot(x1[1:2:end], marker=(:dot,2), markerstroke=:match, label="c₊")
scatter!(x2[1:2:end], marker=(:dot,2), label="c₋")
xlabel!("n")
ylabel!("x_n")
title!("Iteraciones sucesivas")
ylims!(-2, 2.2)

#-
# De la figura anterior podemos ver que, después de un comportamiento inicial
# transitorio, para $c_- < c_3 = -1.75$ el periodo 3 emerge claramente, lo
# que sugiere que la órbita de periodo 3 es estable después de la bifurcación.
# Por otra parte, antes de la aparición de la ventana de periodo 3, para
# $c_3 < c_+$, después del comportamiento transitorio inicial (que tiene que ver con la
# condición inicial $x_0$), los iterados
# sucesivos del mapeo parecen acercarse a la órbita de periodo 3,
# para eventualmente alejarse de ella. Esto se repite varias veces, involucrando
# distinto número de iteraciones. Este comportamiento lo llamaremos
# *intermitencia*.

#-
# El comportamiento *intermitente* se puede entender directamente de la gráfica del
# tercer iterado del mapeo, es decir, de $y = Q_c^3(x)$. Como se observa en la
# siguiente gráfica, para $c>c_3$ la identidad intersecta a la gráfica de
# $Q_c^3(x)$ en dos puntos del dominio ilustrado, uno corresponde a la órbita
# estable de periodo 3 y el otro a la inestable, lo que sugiere que la bifurcación
# creó esos dos puntos fijos. Por otro lado, para $c<c_3$
# no hay intersección con la identidad en el dominio considerado.
# (De hecho, sí se observan dos intersecciones, que corresponden a las órbitas
# de periodo 1, pero que están localizadas en otra región.) La curva punteada
# corresponde a $c=c_3=-1.75$, y claramente muestra una intersección tangente.
# Esta última observación sugiere que, localmente, la bifurcación es similar
# a la bifurcación de centro-silla.

#-
plot( -0.075:1/2^10:-0.035, x->Qc3(x, c₊), linewidth=2, legend=:topleft, label="c=c₊")
plot!(-0.075:1/2^10:-0.035, x->Qc3(x, c₋), linewidth=2, color=:green, label="c=c₋")
plot!(-0.075:1/2^10:-0.035, x->Qc3(x, -1.75), color=:black, linestyle=:dash, label="c=c_3")
plot!(-0.075:1/2^10:-0.035, x->x, linewidth=2, color=:red, label="Identidad")
xlabel!("x")
ylabel!("y = Q_c^3(x)")

#-
# Si consideramos iterados sucesivos *antes* de la bifurcación, para $c>c_3$, y
# en particular con condiciones iniciales cargadas a la derecha ($x_0 \gtrsim -0.055$),
# los iterados muestran un atrapamiento transitorio en esta región,
# para eventualmente escapar de esta región por el lado izquierdo. Esto aclara
# el comportamiento intermitente mostrado arriba para los iterados de $Q_c(x)$ que se
# acercan a los distintos puntos de periodo tres, para eventualmente escapar de su
# cercanía. Dependiendo de la condición inicial, el comportamiento intermitente puede
# durar más o menos, al igual que el tiempo transiente para volver a la cercanía
# de estas regiones de intermitencia. En estas condiciones, uno esperaría tener
# un exponente de Lyapunov positivo.

# ## Periodo 3 implica caos

# Un resultado importante y famoso para mapeos de una dimensión fue establecido por
# Li y Yorke en [Period three implies chaos](https://www.its.caltech.edu/~matilde/LiYorke.pdf),
# (Tien-Yien Li and James A. Yorke, American Mathematical Monthly Vol. 82, No. 10 (1975), pp. 985-992).
# El teorema de Li y Yorke establece que, bajos ciertas condiciones (que en particular se
# satisfacen cuando existen órbitas de periodo 3), (i) existen órbitas periódicas con cualquier
# valor del periodo, y (ii) existe un conjunto no numerable de puntos que no es asintóticamente
# periódico. La primera parte de este teorema es una caso particular del [teorema de
# Sarkovsky](http://www.scholarpedia.org/article/Sharkovsky_ordering), que
# establece un ordenamiento (de los números naturales) en el que
# la aparición de cierto periodo implica la existencia de otros periodos.
# En este apartado mostraremos la idea de la demostración de la primer parte del
# teorema de Li y Yorke.

# Teorema (Li-Yorke): Sea $J$ un intervalo y $F:J\to J$ continua. Supongamos que $a\in J$
# es un punto tal que $b=F(a)$, $c=F^2(a)$ y $d=F^3(a)$ tal que se satisface
#
# \begin{equation}
# d \le a < b < c \quad \textrm{(o } d \ge a > b > c\textrm{)}.
# \end{equation}
#
# Entonces,
# - T1: para toda $k=1, 2, 3, \dots$ extiste un punto periódico de periodo $k$ en $J$
#
# Además,
# - T2: existe un conjunto no numerable $S\subset J$, que no contiene puntos periódicos,
#    que satisface las siguientes condiciones:
#    - (A) Para todo $p,q\in S$, $p\neq q$,
#    \begin{equation}
#    \lim_{n\to\infty} \sup |F^n(p)-F^n(q)| > 0,
#    \end{equation}
#    y,
#    \begin{equation}
#    \lim_{n\to\infty} \inf |F^n(p)-F^n(q)| = 0.
#    \end{equation}
#    - (B) Para todo $p\in S$, y un punto periódico $q\in J$,
#    \begin{equation}
#    \lim_{n\to\infty} \sup |F^n(p)-F^n(q)| > 0.
#    \end{equation}

#-
# El comentario importante es que, si hay un punto periódico con periodo 3 ($a = d$),
# las hipótesis del teorema se satisfacen. T2-B significa que, genéricamente, $p$ es un
# punto que nunca termina en una secuencia periódica, es decir, no es asintóticamente
# periódico.

# La demostración del teorema es una hermosa aplicación del teorema del punto intermedio,
# que recordarán de cálculo. En particular, usando el teorema del punto intermedio
# uno puede demostrar que, si $f(x)$ es una función continua en el intervalo $[a,b]$
# y si el rango de $f(x)$ contiene a $[a,b]$, entonces existe un punto $x_0\in[a,b]$
# tal que $f(x_0)=x_0$, es decir, la aplicación de $f$ a $x_0$ da el mismo resultado. La
# aplicación de este resultado pensando que $f$ es un mapeo es muy clara, ya que si
# se cumplen las condiciones, entonces existe un punto fijo $x_0$ de $f$ en
# $[a,b]$.

# Entonces, para demostrar T1 uno simplemente utiliza el teorema del valor intermedio
# notando que uno puede construir una secuencia de intervalos cerrados $I_k$, tal que
# $I_{k+1}\subseteq f(I_k)$, con $k=0,1,\dots,n-1$, y además $I_n \subseteq I_0$. Esto es,
# el conjunto generado al aplicar $f$ a cada $I_k$ está contenido en $I_{k+1}$, y todos
# los intervalos generados al aplicar $f$ están contenidos en $I_0$.
# En esa situación, entonces existe un punto $x_0$ tal que $f^n(x_0)=x_0$, es decir, que
# es periódico con periodo $n$.

# En el caso del periodo 3, usando la notación del teorema ($a<b<c$, con $f(a)=c$,
# $f(b)=a$, $f(c)=b$), uno define los intervalos $I_0^* = [a,b]$, $I_1^*=[b,c]$, y por el
# teorema del valor intermedio tenemos que $I_0^*,I_1^*\subseteq [a,c] \subseteq f(I_0^*)$,
# ya $I_0^* = [a,b] \subset f(I_1^*)$. Definiendo $I_0^*=I_0=\dots=I_{n-2}$ y
# $I_{n-1}=I_1^*$, y con el resultado anterior para el periodo $n$, tenemos que
# para toda $n$ existe un punto $x_{n}^*$ tal que $f^n(x_{n}^*)=x_{n}^*$.
