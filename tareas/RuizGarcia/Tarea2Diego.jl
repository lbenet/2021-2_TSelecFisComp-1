# # Tarea 2: Exponentes de Lyapunov y universalidad

#-
# > Fecha de envío: 2 de julio
# >
# > Fecha de aceptación: 30 de julio

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
#

#-
# ### Respuesta:


#-
using TaylorSeries
using Plots

function derf(f,a) ## Defino una función que calcula la derivad de una función empleando TaylorSeries.
    t = Taylor1(eltype(a), 1)
    fT = f(a+t)
    return fT[1]
end

## Defino el mapeo cuadrático.
Q²(x,c)=x^2+c





#-
function lyapunov(f,n,x0) ## Primero defino una función que calcula el exponente de Lyapunov.
    s=0 ## INcorporo la recomendación.
    xi=x0
    xf=f(xi)
    for i in 0:n-1
        t1=log(abs(derf(f,xi)))
        s=s+t1
        xi=xf
        xf=f(xi)
    end
    
    return s/n
end     

## Checo si funciona.
lyapunov(x->(x^2)-3/4,10000,1e-20)


#-
## Escribo una función que determina el valor de $c$ para el cual el exponente de Lyapunov se vuelve positivo por primera vez. 
## Lo anterior me ayuda a dar la condición inicial para el método de Newton.

function search_infinite_period(ci,cf,m,x0)
    cs=range(ci,stop=cf,length=m) ## VAlores de c a probar.
    cs=reverse(cs)
    
    c=0
    for k in cs ## Implemento la sugerencia.
        c=k
        lk=lyapunov(x->x^2+c,5000,x0)
        
        if lk ≥ eps(0.0)
            println("c= ",c)
            break
        end
    end
    return c
end

## Calculo el valor de la condición inicial a emplear al buscar los ciclos superestables. No logré obtener el valor que listaba en mi commit anterior (el valor anterior lo obtuve tonteando con mi función).
condin1 = search_infinite_period(-1.40121,-1.40111,100000,1e-20) 


#-
## Refinación de la función de búsqueda

function search_infinite_period_refined(ci,cf,m,x0,nits)
    
    c=search_infinite_period(ci,cf,m,x0) # Valor inicial del parámetro.
    
    for n in 1:nits
        caux=c
        s=(0.1)^(n+5)
        c=search_infinite_period(caux+s,caux-s,m,x0)
    end
    
    return c
end

## Busco la condición incial con mi nueva función.
search_infinite_period_refined(-1.402,-1.401,9000,1e-20,10)

#-
# Terminé no usando el valor obtenido en la celda anterior, pero los resultados del ejercicio 2 no cambian mucho.


#-
## Calculo el exponente de Lyapunov para un rango de c´s.
function lyapunovQPlt(ci,cf,m,x0)
    cs=range(ci,stop=cf,length=m)
    lyaL=ones(Float64,m)
    for k in 1:m
        c=cs[k]
        lyaL[k]=lyapunov(x->x^2+c,2000,x0)
    end
    
    display(lyaL)
    plot(cs,lyaL,xlabel="c",ylabel="λ(c,$x0)",label="",title="Exponente de Lyapunov del mapeo cuadrático",lw=2,color="green",alpha=0.7,legend=:bottomright)
    plot!([1/4,1/4],[-5,1.5],color="blue",label="c=1/4")
    plot!([0,0],[-5,1.5],color="purple",label="c=0")
    plot!([-3/4,-3/4],[-5,1.5],color="red",label="c=-3/4")
    plot!([-5/4,-5/4],[-5,1.5],color="red",label="c=-5/4")
    ylims!((-5,1.5))
    xlims!((ci,cf))
end


#-
# Con la función `lyapunovQPlt(ci,cf,m,x0,limx)` visualizo el exponente de Lyapunov para $c\in [-2,2]$. Marco con líneas verticales rojas los valores de $c$ donde se tiene un doblamiento de periodo para el mapeo $Q^{2}_{c}(x)$.
# Además, con líneas moradas marco los puntos donde tenemos cíclos superestables. 
# Para poder observar el comportamiento del exponente de Lyapunov a detalle, grafico el intervalo $[-2,2]$ a pedazos.


#-
lyapunovQPlt(-1/2,8/4,2000,1e-20) # Podemos observar que $\lambda_{c}$ diverge para c>1/4.

#-
lyapunovQPlt(-3/4,1/4,2000,1e-20) # Podemos observar que $\lambda_{c}$ converge para c<1/4.

#-
lyapunovQPlt(-5/4,1/4,3000,1e-20) 

#-
lyapunovQPlt(-2,(1/4)+0.02,4000,1e-20) 



#-
# Como podemos observar en el diagrama anterior, el exponente de Lyapunov calculado converge solamente para $c\leq \frac{1}{4}$, el cuál es el punto aparecen los puntos periódicos para el mapeo cuadrático. 
# También, podemos ver que en los puntos dónde tenemos un doblamiento de periodo, la curva que caracteriza a $\lambda_{c}$ parece cambiar de concavidad. No solo esto, también parece que los puntos de doblamiento de periodo coinciden con un máximo local de $\lambda_{c}$.


# Es interesante notar que dichos máximos locales siguen siendo negativos. Lo que esto nos indicaría es que, dado un punto $c'$ donde se sucede un doblamiento de periodo, podemos 
# considerar un intervalo $[c'-\varepsilon,c'+\varepsilon]$ tal que $\forall c\in[c'-\varepsilon,c'+\varepsilon]$, $\lambda_{c}(x_{0})\leq 0$. Es decir, en un intervalo centrado en el punto de doblamiento de periodo tendremos comportamiento no caótico.


# Las observaciones que hice arriba solo aplican para los puntos $c=-\frac{3}{4},-\frac{5}{4}$. Si encontramos puntos de doblamiento de  periodo para los cuales $\lambda_{c}>0$, las conclusiones cambian;
# ya que un exponente de Lyapunov positivo indica sensibilidad a condiciones inciales (caos).


# Un último comentario. Del diagrama obtenido podemos concluir que el mapeo cuadrático presenta un comportamiento no caótico para $c\in[-\frac{3}{4},\frac{1}{4}]$.

#-
# ***
# Me faltó identificaar los valores de $c$ para los cuales existen ciclos superestables.
# Para identificar los valores, podemos emplear la herramientas desarrolladas en el notebook de Universalidad.

#-
## Primero definimos las iteraciones del mapeo cuadrado

function Qⁿc(x,c,n)
    if n == 1
        return Q²(x,c)
    else
        for k in 1:n
            x=Q²(x,c)
        end
        return x
    end
end

## Luego, como en la clase, empleamos series de Taylor para implementar el método de Newton. 

function roots_Newton(f,x0,its)
    for k in 1:its
        x0=x0-(f(x0)/derf(f,x0))
    end
    return x0
end
## Pruebo la función.
roots_Newton(c -> Qⁿc(0.0,c,8), -1.4, 400)


#-
# Ahora sí, procedo a hacer el diagrama para $\lambda_{c}(x_0)$ que muestre los valores de $c$ donde se tienen ciclos superestables. Dichos puntos se indican con líneas moradas.


#-
function lyapunovQPlt_complete(ci,cf,m,x0)
    cs=range(ci,stop=cf,length=m)
    lyaL=ones(Float64,m)
    for k in 1:m
        c=cs[k]
        lyaL[k]=lyapunov(x->x^2+c,2000,x0)
    end
    plot(cs,lyaL,xlabel="c",ylabel="λ(c,$x0)",label="",title="Exponente de Lyapunov del mapeo cuadrático",lw=2,color="green",alpha=0.7,legend=:bottomright)
    plot!([1/4,1/4],[-5,1.5],color="blue",label="c=1/4")
    plot!([0,0],[-5,1.5],color="purple",label="c=0",alpha=0.6)
    plot!([-3/4,-3/4],[-5,1.5],color="red",label="c=-3/4")
    plot!([-5/4,-5/4],[-5,1.5],color="red",label="c=-5/4")
    
    ## Calcula las c´s donde existen ciclos superestables
    
    for n in 1:12
        C = roots_Newton(c -> Qⁿc(0.0,c,2^n), condin1, 400) ## Corrijo la condición empleada. Sustituyo por la hallada en una celda anterior.
        println("n= ",n," c= ",C)             
        plot!([C,C],[-5,1.5],label="",alpha=0.6,color="purple")
    end
    ylims!((-5,1.5))
    xlims!((ci,cf))
end


#-
lyapunovQPlt_complete(-2,1/4,4000,1e-20)

#-
lyapunovQPlt_complete(-1.45,0,4000,1e-20)

#-
lyapunovQPlt_complete(-1.42,-1.3,4000,1e-20)

#-
lyapunovQPlt_complete(-1.408,-1.375,4000,1e-20)

#-
# De los diagramas anteriores, podemos notar que los puntos $c$ que corresponden a ciclos superestables del mapeo cuadrático coinciden con 
# mínmos locales de la curva $\lambda_{c}(x_{0})$.  Es interesante notar que todos los puntos superestables que calculamos siguen corresponden a mínimos locales menores a cero.
# Lo anterior es razonable, ya que esperaríamos un comportamiento menos caótico en dichos puntos. 
# Como la curva del exponente de Lyapunov tiene un mínimo local, sabemos que estamos lo más alejados posible del cáos.

# Otro fenómeno interesante es que los valores $c$ correspondientes a ciclos superestables paracen agruparse/amontonarse alrededor de $c=-1.401208$. 
# Esto se debe a que los intervalos donde se produce el doblamiento de periodo decrecen conforme vamos aumentando el periodo.































#-
# ***
# ***
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

#-
# ### Respuesta:
# Calculo los valores $c_{n}$ donde ocurre el ciclo superestable de periodo $2^{n}$ empleando el método de Newton.

#-
function superstable_cs(n)
    cns=zeros(Float64,n+1)
    for k in 1:n   
        C = BigFloat(roots_Newton(c -> Qⁿc(0.0,c,2^k), condin1, 900))
        cns[k+1] = C
    end
    return cns
end
    
function sequence_fn(n)
    cs=superstable_cs(n+1)
    display(cs)
    fs=ones(Float64,n)
    for k in 1:n
        a=BigFloat(cs[k]-cs[k+1])
        b=BigFloat(cs[k+1]-cs[k+2])
        fs[k]=BigFloat(a/b)
    end
    return fs
end


#-
# Empleando mi función `sequence_fn(n)`, estimamos $\delta=\lim_{n\rightarrow \infty}f_{n}\approx f_{5}$.

#-
display(sequence_fn(8)) ## Para n=8 empieza a fallar.


#-
# Parece que $\delta\approx 4.668548581445635$ . El valor reportado en la literatura es $\delta\approx 4.669201$. 
# ***

#-
# Ahora, para el segundo ejercicio, queremos estimar el valor de $\alpha=-\frac{d_{n}}{d_{n+1}}$, donde
# $$
# d_{n}:=\text{min}\{\mid p_{2^{k}}\mid : k\in\{0,...,n-1\}\}.
# $$

# Para calcular $d_{n}$, utilizo los valores $c_{n}$ para obtner un vector que contenga las órbitas perdiódicas del mapeo cuadrático para dicha $c$. Luego, busco el punto de la órbita que se encuentre más cercano al cero. 



#-
function return_min_dist(vec) ## Regresa la distancia mínima al cero de un array. 

    vecaux2 = abs.(setdiff!(vec, [0])) ## Elimina el cero del array y convierte todo a valor absoluto.
    
    ## Luego, considero dos casos. Esto me permite asegurar que no hay problemas.
    daux = minimum(vecaux2) ## Calcula el mínimo del array auxiliar.
    vecaux3 = setdiff!(vecaux2, [daux])
    
    if isempty(vecaux3)
        return daux
    else
        d = minimum(vecaux3)
        return d
    end
end






#-
function α(n)
    cs=superstable_cs(n)
    ## @show(cs)
    ds=zeros(Float64,n+1) 
    αs=zeros(Float64,n)
    
    ## Primero calcula el valor de las d's
    for i in 2:length(ds)
        c=cs[i] ## Valor del parámetro para el cual existe la órbita superestable de periodo 2^(i)
        vecaux=zeros(Float64,2^(n)) ## Vector que guarda la órbias para el mapeo x -> x^2+cs[i]
        for k in 2:length(vecaux)
            x=vecaux[k-1]
            xp=BigFloat((x^2)+c)
            vecaux[k]=xp
        end
        ## @show(vecaux)
        ds[i]= return_min_dist(vecaux)
    end
    ## @show(ds)
    
    for i in 1:n
        a=-(ds[i]/ds[i+1])
        αs[i]=a
    end
     
    return αs

end


#-
α(8) ## Para n=7 empieza a fallar (esto significa que falla para c_{9})


#-
# Aquí obtuve un valor de $\alpha\approx -2.5028783351127877$.
# El valor se aproxima bastante al valor reportado en la literatura: $\alpha\approx -2.50230$.
































#-
# ***
# ***
# ## Ejercicio 3:
#
# Repitan el cálculo de $\delta$ y $\alpha$ a partir de la secuencia definida
# por las $c_n$ para el mapeo $S_c(x) = c \sin(x)$.
#
# - ¿Cómo se comparan los valores obtenidos para $\delta$ y $\alpha$ con los obtenidos
# para $f_n$?
#
# - ¿Qué interpretación le pueden dar al resultado?
#

#-
# ### Respuesta:


#-
# Antes de entrar de lleno a la parte de la programación, necesitamos preguntarnos cómo se 
# ven los ciclos superestables para el mapeo $S_{c}(x):=c\sin(x)$.


# Para el mapeo cuadrático, las órbitas superestables se buscaban al resolver la ecuación 
# $Q_c^{2^{n}}(x=0)=0$, ya que el cero era donde la derivada del mapeo se anulaba.

# Para el nuevo mapeo hago un análisis análogo. Primero, me voy a limitar a trabajar en el 
# intervalo $[0,\pi]$. Derivando 
# $$
# S^{'}_{c}(x)=c\cos(x).
# $$
# Notamos que la derivada se anula en el punto $x^{*}=\frac{\pi}{2}$. Entonces, podemos encontrar los 
# valores de $c$ para los cuales $S_{c}(x)=c\sin(x)$ presenta órbitas superestables al resolver la 
# ecuación 
# $$
# S_c^{2^{n}}(x^{*})-x^{*}=0,
# $$
# para $n\in\mathbb{N}$.


#-
## Primero defino el valor de x^{*}.
xstar = pi/2


#-
## Empiezo definiendo el mapeo y sus composiciones.

Sc(x,c) = c*sin(x)

function Sⁿc(x,c,n)
    if n == 1
        return Sc(x,c) 
    else
        for k in 1:n
            x=Sc(x,c) 
        end
        return x
    end
end

function transcendental_Sc(x,c,n)
    r = Sⁿc(x,c,n)-x
    return r
end




#-
## Estimo la condición inicial para el nuevo mapeo.
using Distributions

function search_infinite_period_s(ci,cf,m,x0)
    cs=range(ci,stop=cf,length=m) ## Valores de c a probar.
    
    lyaL=ones(Float64,m)
    lk=0
    c=0
    for k in 1:length(cs)
        c=cs[k]
        lyaL[k]=lyapunov(x->Sc(x,c),5000,x0)
        lk=lyaL[k]
       
        
        if lk ≥ eps(0.0)
            println("c= ",c)
            break
        end
    end
    return c 
end

search_infinite_period_s(2.71907,2.7191,50000,rand(Uniform(0,pi))) ## Para reducir el rango de parámetros (c's) en el que busco el valor correcto, hice un par de 'zooms' al diagrama de bifurcaciones del mapeo S_{c} al final del ejercicio.




#-
function superstable_qs(n)
    qns=zeros(Float64,n+1)
    for k in 0:n   
        Q = BigFloat(roots_Newton(c -> transcendental_Sc(xstar,c,2^(k)),2.7190804036080722 , 800))
        qns[k+1] = Q
    end
    return qns
end
    
function sequence_fn_Sc(n)
    cs=superstable_qs(n+1)
    display(cs)
    fs=ones(Float64,n)
    for k in 1:n
        a=BigFloat(cs[k]-cs[k+1])
        b=BigFloat(cs[k+1]-cs[k+2])
        fs[k]=BigFloat(a/b)
    end
    return fs
end


#-
## Calculo el valor de δ para el nuevo mapeo.
sequence_fn_Sc(7)

#-
# Parece que $\delta\approx 4.668105671872695$ para el mapeo $S_{c}(x)$. Es interesante notar que la constante $\alpha$ del nuevo mapeo es casi la misma que para el mapeo cuadrático. 
# Al parecer, Feigenbaum descubrió que este comprtamiento universal lo comparten todos los mapeos unidimensionales con un solo máximo cuadrático.
# ***


# Ahora calculo $\alpha$.



#-
function return_min_dist_Sin(vec,val) ## Regresa la distancia mínima al cero de un array. 

    vec =vec.-val
   #  @show(vec)
    vecaux2 = abs.(setdiff!(vec, [0])) ## Elimina el cero del array y convierte todo a valor absoluto.
    
    ## Luego, considero dos casos. Esto me permite asegurar que no hay problemas.
    daux = minimum(vecaux2) ## Calcula el mínimo del array auxiliar.
    vecaux3 = setdiff!(vecaux2, [daux])
    
    if isempty(vecaux3)
        return daux
    else
        d = minimum(vecaux3)
        return d
    end
end




function α_Sin(n)
    cs=superstable_qs(n)
    # @show(cs)
    ds=zeros(Float64,n+1) 
    αs=zeros(Float64,n)
    
    ## Primero calcula el valor de las d's
    for i in 2:length(ds)
        c=cs[i] ## Valor del parámetro para el cual existe la órbita superestable de periodo 2^(i)
        vecaux=Float64[xstar for l in 1:2^(n)] ## Vector que guarda la órbias para el mapeo x -> x^2+cs[i]
        for k in 2:length(vecaux)
            x=vecaux[k-1]
            xp=BigFloat(Sⁿc(x,c,1))
            vecaux[k]=xp
        end
        # @show(vecaux)
        ds[i]= return_min_dist_Sin(vecaux,xstar)
    end
    # @show(ds)
    
    for i in 1:n
        a=-(ds[i]/ds[i+1])
        αs[i]=a
    end
     
    return αs

end


#-
α_Sin(5)


#-
# Parece ser que $\alpha\approx -2.506683425305034$, exhibiendo de nuevo el carácter universal de las constantes de Feigenbaum.









#-
# ***
# Por último, hago el diagrama de bifurcaiones del mapeo $S_{c}(x)$.


#-
using Plots

function bifurcation_Sin(ncs,ns,cin,cfin)
    cs=range(cin,stop=cfin,length=ncs)
    orbits=zeros(Float64,(ns,ncs))
    
    for k in 1:length(cs)
        c=cs[k]
        x0=rand(Uniform(0,pi)) ## Genera el punto inicial.
        aux=zeros(Float64,ns)
        aux[1]=x0
        
        for i in 2:ns
            xn=aux[i-1]
            xnp=Sⁿc(xn,c,1)
            aux[i]=xnp
        end
        orbits[:,k]=aux
    end
    
    return (orbits,cs)
end
    

function pltOrb_Sin(ncs,ns,cin,cfin,args)
    orbits,cs=bifurcation_Sin(ncs,ns,cin,cfin)
    l=size(orbits)[1]
    N=Int(floor(l/4))
    orbitsp=orbits[N:end,:]
    si=size(orbitsp)[1]
        
    p=scatter(Float64[cs[1] for j in 1:si],orbitsp[:,1],xlabel="c",ylabel="x",label="",color="purple",alpha=0.7,ms=0.9,title="Diagrama de órbitas mapeo f(x)=csin(x)",legend=:topleft)
    plot!([cs[1],cs[end]],[xstar,xstar],color="red",label="x*",alpha=0.8)
    plot!([2.7190804036080722,2.7190804036080722],[0,3],color="green",label="",alpha=0.4)
    
    
    for k in 2:length(cs)
        scatter!(Float64[cs[k] for j in 1:si],orbitsp[:,k],color="purple",alpha=0.7,ms=0.9,label="")
    end
    
    if args[1] == false
        plot!([1.5707,1.5707],[0,3],color="blue",label="",alpha=0.6)
        plot!([2.443,2.443],[0,3],color="blue",label="",alpha=0.6)
        plot!([2.658,2.658],[0,3],color="blue",label="",alpha=0.6)
        plot!([2.7063,2.7063],[0,3],color="blue",label="",alpha=0.6)
    end
    
    if args[1]
        ylims!((args[2],args[3]))
    end
    
    return p 
end

#-
# A continuación hago el diagrama de bifurcaciones para el mapeo $S_{c}(c)$. La línea roja horizontal marca el punto $x=x^{*}=\frac{\pi}{2}$, 
# y las líneas azules marcan los valores de $c$ para los cuañes tenemos ciclos superestables.

# La línea verde representa el punto donde el mapeo presenta una órbita infinita. 

#-
oDiag=pltOrb_Sin(300,500,1,3*pi,false)
savefig(oDiag,"diag_bif1.png")

#-
# ![Fig 1](diag_bif1.png "Fig. 1")


#-
oDiag2=pltOrb_Sin(300,1200,1,pi,false) ## Haciendo ´zoom´ en el intervalo [0,pi], que es donde la forma del seno y del mapeo cuadrático es simliar..
savefig(oDiag2,"diag_bif2.png")

#-
# ![Fig 2](diag_bif2.png "Fig. 2")

#-
oDiag3=pltOrb_Sin(420,1600,2.71,2.725,(true,1.4,1.65)) 
savefig(oDiag3,"diag_bif3.png")

#-
# ![Fig 3](diag_bif3.png "Fig. 3")




#-
# Del diagrama de órbitas anterior, podemos notar que el comportamiento cualitativo del mapeo $f_{c}(x)=c\sin(x)$ es básicamente el mismo que el del mapeo cuadrático. La similitud es incluso más evidente si nos restringimos al intervalo $c\in [1,\pi]$, como en la segunda figura .Es por esto que las constantes de Feigenbaum son similares.

# Para seguir divagando un poco, es interesante notar que en la segunda figura todas las órbitas son positivas.


# Algo que también se me ocurre para explicar la similaridad de $\alpha,\delta$ para ambos mapeos es desarrollar en serie de Taylor el mapeo $f_{c}(x)=c\sin(x)$ alrededor del punto donde aparece el primer doblamiento de periodo, esperando que nos quede algo que sea similar al mapeo cuadrático.