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
## Nadamás para completar el ejercicio, hago también la parte computacional.

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
# Ahora calculo el priodo para todos los elementos de $\{1,2,3,4,5\}$. Como todos tienen periodo $5$, confirmamos la imposibilidad del periodo $3$.

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

# Resolviendo $x = x^2 -2$, obtnemos los dos puntos fijos
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

# También podemos ver que combiene hacer el histograma de frecuencias solo para $x\in[-2,2]$, ya que para cualquier $x$ 
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
# Analizando las gráficas anteriores, notamos que la forma del histograma sí depende de la condición inicial. La forma de la 
# distribución para $x_{\pm},q_{\pm}$ son la formas que esperabamos; órbitas periódicas, eventualmente periódicas o puntos fijos. 
# No obstante, es curioso que la distribución es básicamente la misma 
# para cualquier $x_{0}\neq  x_{\pm},q_{\pm},0$. De hecho, si puedo divagar un poco, me parece que la distribución es similar a la de
# el coseno de una variable normal $X$.



