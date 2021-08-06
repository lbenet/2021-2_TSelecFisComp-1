# # Tarea 3: Mapeos abiertos

#-
# > Fecha de envío (PR inicial): 6 de agosto
# >
# > Fecha de aceptación: 13 de agosto
# >
#

# **NOTA**: Esta tarea involucra generar varias imágenes. Para incluirlas
# en la tarea sigan el procedimiento que vimos en clase, es decir, guárdenlas
# en un archivo (extensión .png), que guardan en el mismo directorio y cárguenlas
# usando markdown.


#-
# ## Ejercicio 1:
#
# El objetivo de este ejercicio es mostrar con un ejemplo concreto que periodo 5
# *no implica* periodo 3. El ejercicio lo pueden hacer analítica o numéricamente.
#
# Consideren el mapeo de $F:[1,5]\to[1,5]$ definido tal
# que $F(1)=3$, $F(2)=5$, $F(3)=4$, $F(4)=2$, $F(5)=1$, y en cada intervalo $[n,n+1]$,
# con $n=1, \dots,4$, $F$ es lineal.
# - (a) Muestren que $F$ tiene una órbita de periodo 5.
# - (b) Muestren que $F$ **no** tiene órbita periódica de periodo 3.

#-
#Respuestas


#-
# ## Ejercicio 2:
#
# Estudien las propiedades estadísticas del mapeo cuadrático $Q_c(x)$, con $c=-2$.
# Concretamente, obtengan la distribución de probabilidad (histograma de frecuencias)
# que se obtiene al iterar muchas (¡muchas!) veces un valor inicial cualquiera $x_0$. ¿Depende
# el histograma obtenido de la condición inicial? ¿Qué pueden concluir de esto?

#-
#Respuestas

#-
# ## Ejercicio 3:
#
# Estudien la dinámica para el mapeo cuadrático $Q_c(x)$, con $c=-2.2$.
#
# - ¿Cómo caracterizan el valor al que tiende asintóticamente (muchas iteraciones)
# *casi* cualquier condición inicial en el intervalo $I=[-p_+,p_+]$,
# donde $p_+$ es el valor positivo tal que $Q_c(p_+)=p_+$? (El intervalo
# $I$ es el intervalo donde toda la dinámica *interesante* ocurre.)
#
# - Encuentren una condición inicial concreta  que no siga el comportamiento típico
# que mostraron en el inciso anterior. ¿Cuál es la regla general para encontrar los
# puntos que no satisfacen el comportamiento genérico?
#
# - Caractericen los subconjuntos de condiciones iniciales $I$ tales que, después de
# $n=1,2,3,\dots$ iterados del mapeo, su intersección con $I$ es vacía.
#

#-
#Respuestas

#-
# ## Ejercicio 4:
#
# NOTA: Para este ejercicio es útil que tengan instaladas las paqueterías
# `Images.jl`, `Colors.jl` y `ColorSchemes.jl`, u otras. Sugiero que las instalen
# en la tarea (usando `Pkg.add(...)`) sin guardar los cambios en `Project.toml`
# (es decir, no hagan `git add Project.toml` y `git commit Project.toml` en ningún momento).
#
# Consideren el mapeo $z_{n+1} = z_n^2 + c$ y la condición inicial $z_0 = 0$,
# donde $z_n$ y $c$ son números complejos, y donde variaremos $c$ como número complejo.
# Construiremos el conjunto de Mandelbrot.
#
# - Primero, muestren que si para alguna $n$ $|z_n|^2 > 4$, entonces la evolución
# de la órbita del mapeo diverge, es decir, |z_n| va a crecer indefinidamente.
#
# - Escriban una función que devuelve el número de iteración de $z_0$, dada $c$, en la que
# diverge, es decir, el valor de $n$ cuando $|z_n|^2>4$. Si la condición inicial *no*
# ha divergido hasta el número de pasos máximo (`pasos_max`, que se fija inicialmente),
# la función devolverá `pasos_max+1`. Llamaremos a esta función `numero_pasos`.
#
# - En el plano complejo ($\textrm{Re}(c)$, $\textrm{Im}(c)$) usaremos un código
# de color para representar el número de iterados en que la condición inicial $z_0$
# escapa al variar $c$. Esto es, identificaremos con un color (distinto) la primer $n$ tal que
# $|z_n|^2 > 4$, que se obtiene con la función `numero_pasos`; si llegamos al número
# de pasos máximo (`pasos_max`), usaremos el color negro. (Fuera de la región de
# interés también podemos usar el negro.)
#

#-
#Respuestas

#-
# ## Ejercicio 5:
#

# Consideren de nuevo el mapeo $z_{n+1} = z_n^2 + c$ donde $z_n$ y $c$ son números
# complejos. Definimos $n$ como el número de iteraciones (a partir de $z_0=0$) diverge,
# es decir, $|z_n| > 2$, como en el ejercicio anterior. Consideren $c =-0.75+i y$,
# donde $y$ será variado haciéndolo tender a cero. La idea de este ejercicio es obtener
# una estimación numérica de
# \begin{equation}
# P = \lim_{y\to 0} \left( y n(y) \right).
# \end{equation}
#

#-
#Respuesta

