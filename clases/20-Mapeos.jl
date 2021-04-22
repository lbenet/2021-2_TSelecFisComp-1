
# # Mapeos - Parte 1

#-
# **Referencias:**

# - Robert L. Devaney, A First Course In Chaotic Dynamics: Theory and Experiment, 1992.

# - Heinz Georg Schuster, Wolfram Just, Deterministic Chaos, 2006.

import Pkg
Pkg.activate("..")

#-
# ## Mapeos como sistemas dinámicos

# Los mapeos son aplicaciones de $F_\mu : \mathbb{R}^N \rightarrow \mathbb{R}^N$, 
# donde $N$ es la dimensionalidad del espacio fase que representa el espacio de variables 
# *dinámicas* de interés. (Aquí, escribí que $x\in\mathbb{R}^N$ para ser concretos; uno 
# puede considerar otros conjuntos como dominios del mapeo, como por ejemplo los complejos).

#-
# La idea es definir la dinámica de $x\in\mathbb{R}^N$ a través de la función $F_\mu$ 
# y su aplicación repetida, es decir, 
# \begin{equation}
# x_{n+1} = F_\mu (x_n).
# \end{equation}

# Aquí $\mu$ representa uno o varios parámetros que uno puede variar, y $x_n$ representa 
# el estado del sistema al "tiempo" $n$. La idea al introducir mapeos es evitar las 
# complicaciones que surgen al resolver ecuaciones diferenciales, pudiendo aislar los 
# aspectos importantes que definen las propiedades dinámicas del sistema.

#-
# Una suposición *importante* que haremos sobre $F_\mu$ es que es una función que **no** 
# involucra ningún tipo de variable estocástica o aleatoria. En este caso diremos que el 
# sistema es determinista: el estado al "tiempo" $n+1$ sólo depende del estado al tiempo 
# $n$, y de los parámetros $\mu$ del mapeo, que consideraremos constantes respecto al tiempo.

#-
# *Iterar* la función $F_\mu(x_0)$ significa evaluarla, una y otra vez, de manera repetida, 
# a partir de un valor inicial $x_0$ que llamaremos *condición inicial*. De manera concisa, 
# escribiremos $x_n = F^n_\mu(x_0) = F_\mu(F_\mu(...(F_\mu(x_0))...))$. Otra manera de 
# escribir esto mismo es escribiendo explícitamente cada iterado, es decir, $x_1=F_\mu(x_0)$ 
# representa el primer iterado, $x_2=F_\mu(x_1)=F^2_\mu(x_0)$ el segundo, y en general el 
# $n$-nésimo iterado lo escribiremos $x_n=F_\mu(x_{n-1})=F^n_\mu(x_0)$.

#-
# Por ejemplo, considerando $F(x)=x^2+1$, tendremos
# \begin{eqnarray}
# x_1 & = & F(x_0) = x_0^2+1, \\
# x_2 & = & F^2(x_0) = (x_0^2+1)^2+1,\\
# x_3 & = & F^3(x_0) = ((x_0^2+1)^2+1)^2+1,\\
# x_4 & = & F^4(x_0) = (((x_0^2+1)^2+1)^2+1)^2+1,
# ...
# \end{eqnarray}

# Es claro que la notación $F^n(x)$ no significa la potencia $n$ del mapeo, si no el 
# $n$-ésimo iterado del mapeo.

 
#-
# ## Órbitas

# A la secuencia (ordenada) de los iterados la llamaremos *órbita*, esto es, 
# $x_0, x_1, x_2, \dots$. Así, para el ejemplo anterior con $x_0=0$ tendremos 
# $x_1=1$, $x_2 = 2$, $x_3 = 5$, $x_4 = 26$, etc. Intuitivamente podemos decir que 
# esta órbita tiende a infinito, ya que el valor del $n$-ésimo iterado aumenta, y el 
# siguiente involucrará elevarlo al cuadrado.

#-
# Hay varios tipos de órbitas. Algunas, como vimos antes, pueden diverger; eso depende 
# del mapeo (¡y de la condición inicial!). Otras son más aburridas, en el sentido de que 
# no cambian: son los puntos fijos del mapeo, los cuales evidentemente satisfacen la ecuación
# \begin{equation}
# F_\mu(x) = x.
# \end{equation}
# Esto es, el iterado coincide con la propia condición inicial.

#-
# Por ejemplo, para el mapeo $G(x)=x^2-x-4$, los puntos fijos satisfacen $x^2-2x-4=0$, de 
# donde concluímos que hay dos soluciones, $x_\pm = 1\pm\sqrt{5}$. 

# Por otra parte, para $F(x) = x^2+1$ y $x\in\mathbb{R}$, la ecuación $x^2+1=x$ no tiene 
# solución, por lo que no hay puntos fijos. De hecho, esta es la razón de que todas las 
# órbitas divergen a $+\infty$. (Otra manera de formular esto es que el único punto fijo 
# *atractivo* es $+\infty$.)

#-
# Numéricamente, verificar si cierta condición inicial es un punto fijo de un mapeo es 
# sencillo, pero sutil. Concretamente, para $G(x)$ definido arriba debemos verificar si el 
# iterado $G(x_+)$, por ejemplo, es $x_+$, y lo mismo para $x_-$.

#-
G(x) = x^2 - x - 4  # definimos G(x)

#-
x₊ = 1 + sqrt(5)    # condición inicial, x\_+<TAB>

G(x₊) - x₊ == 0

#-
x₋ = 1 - sqrt(5)    # condición inicial, x\_+<TAB>

G(x₋) - x₋ == 0

#-
# El resultado anterior parece indicar que el iterado de $G(x_-)$ no es $x_-$; esto es a 
# lo que me refería con que la verificación es sutil. 

# La razón por la que no obtenemos el resultado "esperado" son los errores numéricos
# asociados al truncamiento: los números de punto flotante no son los números reales. 
# Usando números de precisión extendida vemos que usando más bits de precisión, 
# $G(x_-) - x_-$ se acerca más a cero.

#-
G(x₋) - x₋

#-
precision(BigFloat)  # Precisión default de `BigFloat`, en "bits"

#-
G(1-sqrt(BigInt(5)))-(1-sqrt(BigInt(5)))

# Otro tipo importante de órbitas son las órbitas periódicas. En este caso tenemos 
# que una secuencia *finita* de iterados se repite a partir de cierta iteración: 
# $x_0, x_1, \dots, x_{n-1}, x_0, x_1, \dots$. El número menor de iterados (de una 
# órbita periódica) tal que se hace aparente la periodicidad se llama *periodo*. 
# Cada punto de dicha órbita es periódico con periodo $n$. Vale la pena notar que 
# los puntos fijos son órbitas periódicas de periodo 1.

#-
# Un punto que pertenece a una órbita de periodo $n$ satisface la ecuación
# \begin{equation}
# F^n(x_0) = x_0.
# \end{equation}

#-
# Claramente, un punto de periodo $n$ del mapeo $F$ es un punto fijo (de periodo 1) 
# del mapeo $F^n$.

#-
# Un punto $x_0$ se llama *eventualmente periódico* cuando sin ser punto fijo o periódico, 
# después de un cierto número *finito* de iteraciones, los iterados pertenecen a una órbita 
# periódica. 

# Un ejemplo, nuevamente para el mapeo $G(x)=x^2-1$, es $x_0=1$: $G(1)=0$, $G^2(0)=-1$, 
# $G^3(-1)=0$, etc.

#-
# En sistemas dinámicos típicos, la mayoría de los puntos no son fijos ni periódicos, 
# ni eventualmente periódicos. Por ejemplo, el mapeo $T(x)=2x$ tiene como punto fijo 
# único, $x^*=0$. Cualquier otra órbita tiende a $\;\pm\infty$, ya que 
# $T^n(x_0) = 2^n x_0$ y entonces $|T^n(x_0)|\to\infty$. 

# En general, la situación es aún más compleja e interesante.

#-
# ## Análisis gráfico

# En lo que sigue ilustraremos una manera gráfica de visualizar la dinámica de mapeos 
# en 1 dimensión.

# Para graficar, usaremos la paquetería `Plots.jl`; por default, el "backend" que se utiliza 
# en `Plots.jl` es `GR.jl`. Uno puede cargar otros, lo que a veces tiene ventajas.
using Plots

# La idea del análisis gráfico es poder visualizar los iterados de una órbita. En el eje 
# de las abscisas dibujaremos $x_n$ y en el de las ordenadas dibujaremos a su iterado, es 
# decir, $F(x_n)$. Entonces, para localizar $x_{n+1}$ simplemente necesitamos la gráfica 
# de $y=F(x)$.

# Usaremos como ejemplo: $F(x) = \sqrt{x}$. Generaremos un número aleatorio entre 0 y 5 
# con `rand` como condición inicial, y calcularemos su iterado.

x0 = 5.0*rand()
x1 = sqrt(x0)
x0, x1

#-
#Dominio (en x) para la gráfica
domx = 0.0:1/32:5.2

# `Plots.jl` se tarda en el primer dibujo dado que inicializa
# varias cosas internamente. Esto funciona mucho mejor en Julia v1.6

#-
#Dibuja F(x) y define escalas, etc. Usa `domx` para generar puntos quese usan
#para pintar la función `sqrt`
plot(domx, sqrt, 
    xaxis=("x", (0.0, 5.0), 0:5.0), 
    yaxis=((0.0, 3.0), "F(x)"), 
    legend=false, title="F(x)=sqrt(x)", grid=false)

#Dibuja x_0 -> x_1 = F(x_0), en la misma grráfica!
#Noten que `Plots` usa vectores, de hecho, cantidades iterables
plot!([x0, x0, 0.0], [0.0, x1, x1], color=:orange)

#Dibuja el punto (x0, x1)
scatter!([x0], [x1], color=:orange, markersize=2)

#-
# Como se trata de *iterar* de manera repetida, lo que ahora requerimos es, en algún 
# sentido, tener a $x_1$ en el eje `x`. Para esto usamos la identidad, i.e., la 
# recta $y=x$. Noten el ligero cambio para que los ejes y el título aparezcan más 
# agradables.

#Dibuja F(x) y define escalas, etc
plot(domx, sqrt, 
    xaxis=("x", (0.0, 5.0), 0:5.0), 
    yaxis=((0.0, 3.0), "F(x)"), 
    legend=false, title="F(x)=sqrt(x)", grid=false)

#Dibuja la identidad; en este caso, usamos la función anónima `x->x`
plot!(domx, x->x, color=:red)

#Dibuja, y une por rectas, los puntos: (x0,0), (x0,x1), (0,x1)
plot!([x0, x0, 0.0], [0.0, x1, x1], color=:orange, lw=2.0)

#A partir del último punto (0,x1), dibuja (x1,x1) y (x1,0)
plot!([0.0, x1, x1], [x1, x1, 0.0], line=(:green, :dash, 2.0, 0.4))

#Dibuja los puntos (x0, x1) y (x1, x1) con un marcador más grande
scatter!([x0, x1], [x1, x1], color=:orange, markersize=2)

# Dado que tenemos $x_1$ en el eje $x$, el mismo proceso de antes
# puede ser implementado para obtener $x_2$, o cualquier otro iterado $x_n$.
# Vale la pena notar que, una vez que estamos en la diagonal, podemos ir
# *directamente* a la función $F(x)$ para obtener $x_2$, y nuevamente a la
# diagonal y a la función para tener $x_3$, etc.

x2 = sqrt(x1)

#Dibuja F(x) y define escalas, etc
plot(domx, sqrt, 
    xaxis=("x", (0.0, 5.0), 0:5.0), 
    yaxis=((0.0, 3.0), "F(x)"), 
    legend=false, title="F(x)=sqrt(x)", grid=false)
    
plot!(domx, x->x, color=:red)

#Dibuja (x0,0), (x0,x1), (x1,x1), (x1,x2), (x2,x2)
plot!([x0, x0, x1, x1, x2], [0.0, x1, x1, x2, x2], 
    line=(:orange, :dash, 2.0))

#Dibuja los puntos (x0, x1) y (x1, x1)
scatter!([x0, x1, x1, x2], [x1, x1, x2, x2], color=:orange, markersize=2)

#-
# **Ejercicio 1**
#
# Completa la función `itera_mapeo`, cuyos argumentos son la función `f`, la condición inicial `x0` y
# el *entero* `n` que indica el número de iteraciones del mapeo. La función debe devolver *tres*
# *vectores*: uno que incluya la secuencia de iterados (incluyendo a la condición inicial), y otros dos
# que podrás usar para el análisis gráfico. Haz una prueba sencilla para $F(x) = \sqrt{x}$.
# Completa además los "docstrings".

"""
    itera_mapeo(f, x0, n)

"""
function itera_mapeo(f, x0, n::Int)
    #(código)
    return its, its_x, its_y
end

#-
#Prueba de que itera_mapeo(f, x0, n) funciona

#-
# **Ejercicio 2**
# 
# (a) Completa la función `analisis_grafico` (ver la siguiente celda), de tal manera que usándola se obtenga el 
# tipo de gráficas ilustradas arriba. Esto es, que se grafique el mapeo `F` y la identidad, y los `n` siguientes 
# iterados a partir de la condición inicial `x0`. El argumento (opcional) `domx` debe especificar el dominio que 
# se grafica. Utiliza la función `itera_mapeo` definida en el ejercicio anterior. Completa también los "docstrings". 
# Es útil tener otra función `analisis_grafico!` que sólo *actualice* la figura creada por `analisis_grafico` al 
# iterar otra condición inicial.
# 
# (b) Usa la función `analisis_grafico` para describir el mapeo $F(x)=\sqrt{x}$, usando tres condiciones iniciales 
# distintas. (Es aquí que la función `analisis_grafico!` es particularmente útil para dibujar sobrer una gráfica previa.)
# 
# (c) ¿Qué se puede concluir al iterar *muchas* veces distintas condiciones iniciales para $F(x)=\sqrt(x)$?
# 
# (d) ¿Cuántos puntos fijos tiene el mapeo $F(x) = \sqrt{x}$?
# 
# (e) A partir de la gráfica del mapeo, ¿cómo se obtienen los puntos fijos del mapeo?

#-
"""
    analisis_grafico(F::Function, x0::Float64, n::Int)

"""
function analisis_grafico(F::Function, x0::Float64, n::Int, domx=0.0:1/128:1.0)
    #(código)
end

#-
"""
    analisis_grafico!(F::Function, x0::Float64, n::Int)

"""
function analisis_grafico!(F::Function, x0::Float64, n::Int, domx=0.0:1/128:1.0)
    #(código)
end

#-
#(Respuestas)
