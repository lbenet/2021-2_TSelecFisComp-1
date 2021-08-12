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
# A mi apreciación, las distribuciones del mapeo cuadrático se parecen a la del coseno mostrada arriba. Eso es notable, ya que la distribución
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
        if abs(x) < 3.3
            push!(finites,x0)
        end
    end

    return finites
end

mts=mult_time_series_2(x->Qc(x,-2.2),80,-p₊,p₊,2000001)


#-
# Implementando una división del intervalo extremadamente fina, encontramos varias condiciones iniciales que no divergen.
# Procedo a visualizarlas.


#-
scatter1=scatter(mts,ones(Int8,length(mts)),color="green",ms=3.5,alpha=0.8,xlabel="x's finitas",label="")
ylims!((0,2))
savefig(scatter1,"scatter1.png")

#-
# ![Fig 16](scatter1.png "Fig. 16")


#-
# Viendo la gráfica anterior, se me ocurrió que tal vez los puntos tengan algo que ver con el conjunto de Cantor. Como no se me ocurrió 
# una forma analítica de probar la intuición, opte por visualizar el conjunto de Cantor.

#-
function cantor(n,limits)
    cantor = Vector{Float64}[[limits[1],limits[2]]]

    for k in 1:n
        cantoraux = Vector{Float64}[]
        for el in cantor
            xi = el[1]
            xf = el[2]
            d = (xf-xi)/3
            new1 = [xi,xi+d]
            new2 = [xf-d,xf]
            push!(cantoraux,new1,new2)
        end
        cantor = copy(cantoraux)
    end
    return cantor
end



function plt_cantor(n,limits)
    vec = cantor(n,limits)
    
    plt=plot(vec[1],[1.2,1.2],color="purple",lw=2,alpha=0.7,xlabel="",ylabel="",label="")
    xlims!(limits)
    ylims!((0,2))
    
    for k in 2:length(vec)
        vek = vec[k]
        plot!(vec[k],[1.2,1.2],color="purple",lw=3.3,alpha=0.7,label="")
    end
    display(plt)
end

#-
## Pruebo el funcionamiento
cantor(2,(0,1))

#-
## Hago la gráfica.
cantor = plt_cantor(5,(-p₊,p₊))
savefig(cantor,"cantor.png")

#-
# ![Fig 17](cantor.png "Fig. 17")


#-
# Desgraciadamente, mi gráfica del conjunto de cantor no se ve tan similar a los puntos iniciales de la figura 16. 
# No estoy seguro sobre cómo proceder.

# ***
# Notemos que en podemos emplear la función `Qⁿc(x,c,n)` para iterar muchas veces el mapeo. Grafico dicha función
# sobre el intervalo $I=[-p_{+},p_{+}]$ para darme una idea de qué puntos quedan dentro del mismo intervalo 
# luego de `n` iteraciones del mapeo cuadrático.

#-
function Qⁿc(x,c,n)
    if n == 1
        return Qc(x,c) 
    else
        for k in 1:n
            x=Qc(x,c) 
        end
        return x
    end
end


#-
function plt_Qⁿc(c,n,m)
    pran = range(-p₊,stop=p₊,length=m)
    vals = broadcast(x->Qⁿc(x,c,n),pran)
    
    escapes = Float64[]
    
    for k in 1:length(vals)
        v = vals[k]
        if abs(v) > p₊ 
            push!(escapes,pran[k])
        end
    end
        
    plt=scatter(pran,vals,ms=1.5,color="blue",alpha=0.4,xlabel="x",ylabel="Qⁿc",title="n=$n",label="",legend=:bottomright)
    scatter!(escapes,zeros(Int8,length(escapes)),ms=0.8,color="red",alpha=0.2,label="salen de I")
    xlims!((-p₊,p₊))
    ylims!((-p₊,p₊))
    
    return (plt,escapes)
end


#-
iters1=plt_Qⁿc(-2.2,1,100000)
savefig(iters1[1],"iters1.png")

iters2=plt_Qⁿc(-2.2,2,100000)
savefig(iters2[1],"iters2.png")

iters3=plt_Qⁿc(-2.2,3,100000)
savefig(iters3[1],"iters3.png")

iters4=plt_Qⁿc(-2.2,4,100000)
savefig(iters4[1],"iters4.png")

iters5=plt_Qⁿc(-2.2,5,100000)
savefig(iters5[1],"iters5.png")

iters6=plt_Qⁿc(-2.2,6,100000)
savefig(iters6[1],"iters6.png")

iters7=plt_Qⁿc(-2.2,7,100000)
savefig(iters7[1],"iters7.png")


#-
# En las graficas anteriores ya obtuve los intervalos cuya intersección con $I$ ya es vacía. 
# No obstante, no se me ocurre una regla anaáloga a la del conjunto de Cantor para construirlos.




























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

## Podemos mostrar que los valores absolutos no convergen con un ejemplo numérico.
using Distributions
Qc(x,c) = x^2+c

function conv_comp(c,r,m,n)
    thetasp=rand(Uniform(0,2*pi),m)
    vals = zeros(Float64,m)
    
    cont = 1 
    for θ in thetasp
        z0 = r*exp(θ*im) ## Condición inicial
        for k in 1:n
            z0 = Qc(z0,c)
        end
        vals[cont] = abs(z0)
        cont = cont +1
    end
    return vals
end         

#-
# ***


#-
## Como podemos ver, incluso para una modulo cuadrado ligeramente mayor a 4, las secuencias divergen, independientemente del ángulo y del parámetro c

conv_comp(1+0.5im,sqrt(4.0000001),12,10)

#-

conv_comp(0.1+0.2im,sqrt(4.0000001),12,10)


#-
# ***

#-
## Escribo la función `numerp_pasos`.
function numero_pasos(c,pasos_max)
    z0 = 0 +0im
    n = 0
    for k in 1:pasos_max
        n = n+1
        z0 = Qc(z0,c)
        m = abs2(z0) ## Calcula el módulo cuadrado.
        
        if m > 4
            return n
        end
    end
    return pasos_max+1
end

## Veo que funcione
numero_pasos(0.1-0.5im,300)


#-
# ***
# Termino por hacer un `heatmap` del conjunto de Mandelbrot (como dios mejor me dió a entender).

#-
function complex_plane(argsx,argsy)
    cs = zeros(Complex{Float64},(argsy[3],argsx[3]))
    
    xs = range(argsx[1],stop=argsx[2],length=argsx[3])

    ys = range(argsy[1],stop=argsy[2],length=argsy[3])
    for i in 1:argsx[3], j in 1:argsy[3]
        x = xs[i]
        y = ys[j]
        c = x + im*y
        cs[j,i] = c
    end
    return (cs,xs,ys)
end

#-
using ColorSchemes, Plots

function mandelbrot(pasos_max)
    cs,xs,ys = complex_plane((-2,1,500),(-1,1,500)) ## Genero el conjunto de parámetros.
    np = broadcast(c->numero_pasos(c,pasos_max),cs)
    
    heatmap(xs,ys,np, c = :curl)
    
end


#-
mand=mandelbrot(50)
savefig(mand,"mand.png")

#-
# ![Fig 18](mand.png "Fig. 18")





























#-
# ## Ejercicio 5:
 
# Consideren de nuevo el mapeo $z_{n+1} = z_n^2 + c$ donde $z_n$ y $c$ son números
# complejos. Definimos $n$ como el número de iteraciones (a partir de $z_0=0$) diverge,
# es decir, $|z_n| > 2$, como en el ejercicio anterior. Consideren $c =-0.75+i y$,
# donde $y$ será variado haciéndolo tender a cero. La idea de este ejercicio es obtener
# una estimación numérica de
# \begin{equation}
# P = \lim_{y\to 0} \left( y n(c(y)) \right).
# \end{equation}

# ### Respuesta:

#-
c(y) = -0.75 +im*(y)

function estimate_P(yi,yf,nys,pasos_max)
    ys = range(yi,stop=yf,length=nys)
    ps = zeros(Float64,nys)
    
    cont=1
    for y in reverse(ys)
        n = numero_pasos(c(y),pasos_max)
        ps[cont] = n*y
        cont = cont+1
    end
    return (ps,ys)
end 


#-
## Estimo el valor de P.
ps=estimate_P(1e-10,0.01,200,200)[1]

#-
## También hago una gráfica de como converge P, al menos hasta cierto punto.
using Statistics

function plt_ps(yi,yf,nys,pasos_max) 
    ps,ys =  estimate_P(yi,yf,nys,pasos_max)
    papprox = 0
    for k in 1:length(ps)-1
        p1 = ps[k]
        p2 = ps[k+1]
        d = abs(p1-p2)
        if d > 0.1
            papprox = ps[k]
            @show(papprox)
            break
        end
    end
    scatter(reverse(ys),ps,ms=4,color="red",xlabel="y",ylabel="P",label="",alpha=0.3)
    plot!([0,yf],[papprox,papprox],color="blue",lw=1.5,alpha=0.8,label="mejor aproximación P=$papprox",legend=:bottomright)
end

pp1=plt_ps(1e-8,0.01,100,9000)
savefig(pp1,"pp1.png")

#-
# ![Fig 19](pp1.png "Fig. 19")

#-
# Según mi estimación, parecería que $P\approx 3.1418928$. El número es sospechosamente parecido a $\pi$. Para obtener un mejor
# calculo, es necesario refinar la aproximación. Esto se logra al:
# - aproximarnos más cerca al cero (en vez de parar en `1e-8` paro en `1e-11`).
# - aumentar el número de puntos en el intervalo.
# - aumentando la tolerancia `pasos_max` en el cálculo de $n(c(y))$.



#-
pp2=plt_ps(1e-11,0.01,1000,1e7) ## Implemento la sugerencia.
savefig(pp2,"pp2.png")

#-
# ![Fig 20](pp2.png "Fig. 20")

#-
# Con la refinación anterior obtuve $P\approx 3.1415947269$, valor que se compara favorablemente a $\pi=3.1415926535897932...$
# Como último comentario,menciono que mi aproximación mejoró con respecto a mi commit anterior ya que no consideré el valor
# del promedio. En vez de esto, tomé el último número que sí parecía converger a un número distinto de cero.


