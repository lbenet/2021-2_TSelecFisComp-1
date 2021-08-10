#-
# # Tarea 3: Mapeos abiertos

#-
# > Fecha de envío (PR inicial): 6 de agosto
# >
# > Fecha de aceptación: 13 de agosto
# >

#-
# **NOTA**: Esta tarea involucra generar varias imágenes. Para incluirlas
# en la tarea sigan el procedimiento que vimos en clase, es decir, guárdenlas
# en un archivo (extensión .png), que guardan en el mismo directorio y cárguenlas
# usando markdown.

#-
# ## Ejercicio 1:

# El objetivo de este ejercicio es mostrar con un ejemplo concreto que periodo 5
# *no implica* periodo 3. El ejercicio lo pueden hacer analítica o numéricamente.

# Consideren el mapeo de $F:[1,5]\to[1,5]$ definido tal
# que $F(1)=3$, $F(2)=5$, $F(3)=4$, $F(4)=2$, $F(5)=1$, y en cada intervalo $[n,n+1]$,
# con $n=1, \dots,4$, $F$ es lineal.
# - (a) Muestren que $F$ tiene una órbita de periodo 5.
# - (b) Muestren que $F$ **no** tiene órbita periódica de periodo 3.

#-
# ### Respuesta:

# Supongamos que la condición incial es $x_{0}=1$. Entonces, bajo la acción del mapeo $F$ tendremos la siguiente órbita
# $$
# 1 \xrightarrow[F]{} 3 \xrightarrow[F]{} 4 \xrightarrow[F]{} 2 \xrightarrow[F]{} 5 \xrightarrow[F]{}1.
# $$
# Lo anterior prueba la existencia de una órbita de periodo $5$.

# La "ecuación" anterior también nos ayuda a argumentar por qué no existe una órbita de periodo 3. 
# Esto se debe a que, siendo $x_{1}\in\{1,2,3,4,5\}$, la órbita de arriba incluye a $x_{1}$. Entonces, 
# no existe la posibilidad de una órbita de periodo $3$.

#-
## Nada más para completar el ejercicio, hago también la parte computacional.

function map_F(x)
    if x == 1
        return 3
    elseif x == 2
        return 5
    elseif x == 3 
        return 4
    elseif x == 4
        return 2
    else
        return 1
    end
end


function period(f,x1,nits)
    ## Primero lleno un array con los iterados del mapeo
    xs = zeros(Float64,nits+1)
    xs[1] = x1
    
    for k in 2:nits+1
        xs[k] = f(xs[k-1])
    end
    
    ## Ahora busco el periodo de la órbita.
    p = 0
    
    for x in xs[2:end]
        p = p+1
        
        if x == x1
            break
        end
    end
   
    return p
end

#-
# Ahora calculo el periodo para todos los elementos de $\{1,2,3,4,5\}$. Como todos tienen periodo $5$, confirmamos la imposibilidad del periodo $3$.

#-
period(map_F,1,7)

#-
period(map_F,2,7)

#-
period(map_F,3,7)

#-
period(map_F,4,7)

#-
period(map_F,5,7)
























#-
# ## Ejercicio 2:

# Estudien las propiedades estadísticas del mapeo cuadrático $Q_c(x)$, con $c=-2$.
# Concretamente, obtengan la distribución de probabilidad (histograma de frecuencias)
# que se obtiene al iterar muchas (¡muchas!) veces un valor inicial cualquiera $x_0$. ¿Depende
# el histograma obtenido de la condición inicial? ¿Qué pueden concluir de esto?

# ### Respuesta:

# Antes de empezar a escribir código, podemos ver qué pasa con el mapeo $Q_{-2}(x)$.

# Resolviendo $x = x^2 -2$, obtenemos los dos puntos fijos
# $$
# \begin{align}
# x_{+} & = 2,\\
# x_{-} & = -1.\\
# \end{align}
# $$

# Para conocer la estabilidad de estos puntos fijos, evaluamos $Q^{'}_{c}(x)=2x$ en $x_{\pm}$. 
# Notamos que ambos puntos son inestables.

# También podemos conocer los puntos que constituyen las órbitas de periodo $2$ al calcular los puntos fijos del mapeo $Q_{c}^{2}$. 
# Según lo visto en clase, dichos puntos son $x_{\pm}$ y 
# $$
# \begin{align}
# q_{+} & = 0.6180339887498949,\\
# q_{-} & = -1.618033988749895.\\
# \end{align}
# $$
# Los resultados anteriores son importantes, ya que si iniciamos el mapeo en $x_{\pm},q_{\pm}$, el histograma tendrá solo tendrá una o 
# dos "barras". Entonces, sabemos a priori que el histograma si depende de la condición inicial.

# También podemos ver que conviene hacer el histograma de frecuencias solo para $x\in[-2,2]$, ya que para cualquier $x$ 
# fuera del intervalo el mapeo diverge. Por poner un ejemplo, consideremos $x_{0}=2.1$. Entonces
# $$
# 2.1\xrightarrow[Q]{} 2.41 \xrightarrow[Q]{} 3.8 \xrightarrow[Q]{} 12.5 \xrightarrow[Q]{} 154.29\dots \xrightarrow[Q]{} \infty.
# $$

# Por lo tanto, en el análisis que sigue me restrinjo al intervalo $[-2,2]$.

#-
using Plots

Qc(x,c) = x^2+c

function cuad_hist(c,x₀,nits)
    xs = zeros(Float64,nits+1)
    xs[1] = x₀
    
    for j in 2:nits+1
        xs[j] = Qc(xs[j-1],c)
    end

    histogram(xs,nbins = 26,color="purple", alpha=0.5,label="",legend=:topright, title = "Frecuencia de iterados para mapeo cuadrático \n x₀ = $x₀")
    xlabel!("Intervalo")
    ylabel!("Frecuencia")
    xlims!((-2.3,2.3))
end



#-
hist1=cuad_hist(-2,0.6180339887498949,100000)
savefig(hist1,"hist1.png")

hist2=cuad_hist(-2,2,100000)
savefig(hist2,"hist2.png")

hist3=cuad_hist(-2,1.9,100000)
savefig(hist3,"hist3.png")

hist4=cuad_hist(-2,1.5,100000)
savefig(hist4,"hist4.png")

hist5=cuad_hist(-2,1,100000)
savefig(hist5,"hist5.png")

hist6=cuad_hist(-2,0.66,100000)
savefig(hist6,"hist6.png")

hist7=cuad_hist(-2,0.1,100000)
savefig(hist7,"hist7.png")

hist8=cuad_hist(-2,0,100000)
savefig(hist8,"hist8.png")

hist9=cuad_hist(-2,-0.1,100000)
savefig(hist9,"hist9.png")

hist10=cuad_hist(-2,-0.9,100000)
savefig(hist10,"hist10.png")

hist11=cuad_hist(-2,-1,100000)
savefig(hist11,"hist11.png")

hist12=cuad_hist(-2,-1.1,100000)
savefig(hist12,"hist12.png")

hist13=cuad_hist(-2,-1.9,100000)
savefig(hist13,"hist13.png")

hist14=cuad_hist(-2,-2,100000)
savefig(hist14,"hist14.png")



#-
# ![Fig 1](hist1.png "Fig. 1")

#-
# ![Fig 2](hist2.png "Fig. 2")

#-
# ![Fig 3](hist3.png "Fig. 3")

#-
# ![Fig 4](hist4.png "Fig. 4")

#-
# ![Fig 5](hist5.png "Fig. 5")

#-
# ![Fig 6](hist6.png "Fig. 6")

#-
# ![Fig 7](hist7.png "Fig. 7")

#-
# ![Fig 8](hist8.png "Fig. 8")

#-
# ![Fig 9](hist9.png "Fig. 9")

#-
# ![Fig 10](hist10.png "Fig. 10")

#-
# ![Fig 11](hist11.png "Fig. 11")

#-
# ![Fig 12](hist12.png "Fig. 12")

#-
# ![Fig 13](hist13.png "Fig. 13")

#-
# ![Fig 14](hist14.png "Fig. 14")


#-
# Analizando las gráficas anteriores, notamos que la forma del histograma solo depende de la condición inicial si 
# $x_{0}=x_{\pm},q_{\pm},0$. Esto se debe a que los puntos antes mencionados dan a lugar órbitas cerradas, periódicas o eventualmente
# periódicas.

# En cambio, para el resto de puntos, la distribución es básicamente la misma.
# A mi me parece que la distribución resultante es similar a la de
# el coseno de una variable normal $X$.

#-
## No considero que el comentario sobre lo del coseno tenga mucha relevancia, tan solo estaba especulando. Igual hago una gráfica para 
## mostrar la similitud.
using Distributions


thetasp=rand(Uniform(-pi,pi),3000)
## Calculo el coseno de la variable aleatoria unforme
ap=cos.(thetasp)

distcos=histogram(ap,nbins=30,color="cyan", alpha=0.5,legend=:topright,label="",title="")
xlabel!("Valor de cos(x)")
ylabel!("Frecuencia")
xlims!(-1,1)
savefig(distcos,"distcos.png")

#-
# ![Fig 15](distcos.png "Fig. 15")

#-
# A mi apreciación, las distrbuciones del mapeo cudrático se parecen a la del coseno mostrada arriba. Eso es notable, ya que la distribución
# del coseno de la figura anterior muestra la distribución de una variable aleatoria.
























#-
# ## Ejercicio 3:

# Estudien la dinámica para el mapeo cuadrático $Q_c(x)$, con $c=-2.2$.

# - ¿Cómo caracterizan el valor al que tiende asintóticamente (muchas iteraciones) *casi* cualquier condición inicial en el intervalo $I=[-p_+,p_+]$, donde $p_+$ es el valor positivo tal que $Q_c(p_+)=p_+$? (El intervalo $I$ es el intervalo donde toda la dinámica *interesante* ocurre.)

# - Encuentren una condición inicial concreta  que no siga el comportamiento típico que mostraron en el inciso anterior. ¿Cuál es la regla general para encontrar los puntos que no satisfacen el comportamiento genérico?

# - Caractericen los subconjuntos de condiciones iniciales $I$ tales que, después de $n=1,2,3,\dots$ iterados del mapeo, su intersección con $I$ es vacía.


# ### Respuesta:
# Según lo visto en los notebooks de la clase, el valor $p_+$ está dado por
# $$
# p_+ = \frac{1+\sqrt{9.8}}{2}\approx 2.0652475842498528.
# $$

# Procedo a realizar una serie de tiempo del mapeo $Q_c$ para diversos valores iniciales $x_0\in[-p_+,p_+]$.


#-
p₊= BigFloat((1+sqrt(9.8))/2)

#-
Qc(x,c) = BigFloat(x^2+c)

function iterate_map(f,nits,x0)
    for k in 1:nits
        x0 = f(x0)
    end
    return x0
end

function mult_time_series(f,nits,xi,xf,nxs)
    ## Primero creo una matriz con todos los valores
    interval = range(xi,stop=xf,length=nxs)
    vals = zeros(Float64,nxs)
    
    c=1
    for x0 in interval
        x = iterate_map(f,nits,x0)
        vals[c]=x
        c=c+1
    end
    
    return vals
end




#-
mult_time_series(x->Qc(x,-2.2),100,-p₊,p₊,14)

#-
# Como podemos observar en la celda anterior, todos las condiciones iniciales empleadas divergen asintóticamente. Ni 
# siquiera se requiere un gran número de iteraciones.

#-
# Como se nos pide encontrar los puntos de $I$ que no llevan a un comportamiento asintótico divergente, refino el rango de
# condiciones iniciales empleado. Busco cuáles condiciones iniciales resultan en un iterado final finito.

#-
function mult_time_series_2(f,nits,xi,xf,nxs)
    ## Primero creo una matriz con todos los valores
    interval = range(xi,stop=xf,length=nxs)
    finites = Float64[]
    
    for x0 in interval
        x = iterate_map(f,nits,x0)
        if x < 10^10
            
            push!(finites,x)
        end
    end

    return finites
end

mult_time_series_2(x->Qc(x,-2.2),70,-p₊,p₊,80000)


#-
# Parece ser que $\abs{x_0}=0.4837644780717008$ resulta en iterados finitos. Aunque, intenté aumentar el número de iteraciones y para `nits=80` 
# ya no se obtienen iterados finitos.
















#-
# ## Ejercicio 4:

# NOTA: Para este ejercicio es útil que tengan instaladas las paqueterías
# `Images.jl`, `Colors.jl` y `ColorSchemes.jl`, u otras. Sugiero que las instalen
# en la tarea (usando `Pkg.add(...)`) sin guardar los cambios en `Project.toml`
# (es decir, no hagan `git add Project.toml` y `git commit Project.toml` en ningún momento).

# Consideren el mapeo $z_{n+1} = z_n^2 + c$ y la condición inicial $z_0 = 0$,
# donde $z_n$ y $c$ son números complejos, y donde variaremos $c$ como número complejo.
# Construiremos el conjunto de Mandelbrot.

# - Primero, muestren que si para alguna $n$ $|z_n|^2 > 4$, entonces la evolución
# de la órbita del mapeo diverge, es decir, $|z_n|$ va a crecer indefinidamente.

# - Escriban una función que devuelve el número de iteración de $z_0$, dada $c$, en la que
# diverge, es decir, el valor de $n$ cuando $|z_n|^2>4$. Si la condición inicial *no*
# ha divergido hasta el número de pasos máximo (`pasos_max`, que se fija inicialmente),
# la función devolverá `pasos_max+1`. Llamaremos a esta función `numero_pasos`.

# - En el plano complejo ($\textrm{Re}(c)$, $\textrm{Im}(c)$) usaremos un código
# de color para representar el número de iterados en que la condición inicial $z_0$
# escapa al variar $c$. Esto es, identificaremos con un color (distinto) la primer $n$ tal que
# $|z_n|^2 > 4$, que se obtiene con la función `numero_pasos`; si llegamos al número
# de pasos máximo (`pasos_max`), usaremos el color negro. (Fuera de la región de
# interés también podemos usar el negro.)

# ### Respuesta:



#-




















#-
# ## Ejercicio 5:
 
# Consideren de nuevo el mapeo $z_{n+1} = z_n^2 + c$ donde $z_n$ y $c$ son números
# complejos. Definimos $n$ como el número de iteraciones (a partir de $z_0=0$) diverge,
# es decir, $|z_n| > 2$, como en el ejercicio anterior. Consideren $c =-0.75+i y$,
# donde $y$ será variado haciéndolo tender a cero. La idea de este ejercicio es obtener
# una estimación numérica de
# \begin{equation}
# P = \lim_{y\to 0} \left( y n(y) \right).
# \end{equation}

# ### Respuesta:

#-


#-









