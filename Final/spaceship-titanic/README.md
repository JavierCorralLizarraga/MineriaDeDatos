## Comprehensión del Negocio

### Antecedentes

En el escenario hipotético que plantea este desafía, en el año 2912 el navío espacial *Titanic* llevaba a cabo un viaje a 3 exoplanetas habitables para su colonización cuando se encontró con una anomalía espacio-temporal que transportó la mitad de los pasajeros a una dimensión alterna. Sin embargo, el navío sigue intacto y fue posible recopilar información para algunos respecto a si fueron transportados o no, y los records computacionales han registrado en base de datos una variedad de información de los pasajeros. En concreto, para cada pasajero se conoce lo siguiente:
- `PassengerId`, el número ID de los pasajeros
- `HomePlanet`, el planeta de donde abordaron
- `CryoSleep`, que indica sí viajaron en animación suspendida o no
- `Cabin`, que indica la cabina en que se hospedan, en formato nivel/número/lado
- `Destination`, que indica el destino a que debían llegar; `Age`, la edad
- `VIP`, que indica si se pagó extra por VIP
- `RoomService`, `FoodCourt`, `ShoppingMall`, `Spa`, `VRDeck`, son cada una las cantidades de dinero pagadas en estas amenidades respectivos del crucero
- `Name`, el nombre y apellido del pasajero
- `Transported`, que indica si fueron transportados o no. 

### Determinación del Objetivo

El objetivo final de este desafío es poder determinar, mediante la información del archivo `train.csv` que tiene toda las variables antes mencionadas, un modelo de clasificación binaria que a los viajeros de `test.csv`, que presenta toda la información anterior menos `Transported`, pueda asignarseles la variable faltante de manera correcta. A la clasificación dada a todos los viajeros en `test.csv` se dará un formato de pares ID:Transportado.

### Determinación del Criterio de Éxito

En la práctica se varios métodos de modelado distintos, ya ajustados con hiperparámetros mejor optimizados usando grid search, para estos, el criterio de éxito que determina el que se usará se basa en la comparación de la matriz de confusión y de la curva de exito generada al probar los modelos sobre el subconjunto de prueba (esta es distinta al presente en `test.csv`como esta es sobre la que el desafío evalua el resultado y por lo tanto no da el resultado correcto a-priori para evaluarlo, por lo que el subconjunto de prueba es elegido de un 25% predeterminado de `train.csv`).

### Plan de Proyecto

## Preparación de los Datos
El proceso de preparación de los datos es llevada a cabo en el archivo `main.R`, usando información de los archivos `utils.r` y `clean.r`. En primer lugar el archivo `train.csv` se lee y se guarda a un archivo RDS, en caso de no haberse guardado previamente, y se le da el nombre de variable `titanic_train` Aquí, la función `problems()` no encuentra ninguna filas, indicando que no hay filas desplazadas por falta de comas, de donde el único proceso de limpieza estrictamente necesaria fue la imputación de los datos, que llevamos a cabo usando el paquete `VIM`, que provee una función de imputación por similitud de K-medias. 

Sin embargo, antes de imputarse, se llevo a cabo ingeniería de características para incrememntar la facilidad de usar las variables e interpretarlas. Para esto, a la variable 'ID' se separó en dos los componentes a cada lado del guión, `grupo` y `id`, que sirve para identificar más fácilmente a viajeros que andaban juntos, como la primera parte registrada en `grupo`es la misma para todos los viajeros que reservaron en un mismo grupo. También, a la variable `Cabin`, que consiste de tres partes separados por diagonal, se separó en sus tres coponentes como variables separadas `deck`, `room_num` y `side`. Adicionalmente, al nombre se separó en su primer nombre `fname` y apellido `lname` ya que viajeros con mismos apellidos similares podrian estar relacionados por familia. Finalmente, se generó una variable nueva `gastos`que suma todos los gastos registrados para cada viajero para más fácil visualización.

Así, de este proceso resulta una variable `titanic_train` que será usado para la comprensión de datos, y a esta variable también se pasa a la función `write_feather` para usarse en python en el modelado. A este proceso que se lleva a cabo sobre `train.csv` se repite sobre `test.csv` para de este generar la lista de predicciones.

## Comprensión de los Datos

Para visualizar los datos se usó una aplicación Shiny llamado `el_chaini`que usa la variable `titanic_train` ya generada anteriormente. En esta aplicación se puede elegir las variables (menos el nombre y apellido, como son demasiadas categorías posibles y no pareció relevante agruparlos por, por ejemplo, primera letra) para visualizar gráficas en una variable, bivariadas, y multivariadas. Para el análisis univariado, se muestran graficas de barra, agrupadas por factor en caso de variables factor o mostrado en 41 *bins* en caso de numéricos; para el analisis multivariado se usan gráficas de dispersión para dos variables numéricas, gráficas caja para unavariable categórica sobre una numérica, y una gráfica barra separado en colores para dos categóricas. Para el multivariado se hizo analisis de componentes principales y se realizó una gráfica de dispersión sobre los dos más grandes, coloreando los puntos según su categoría, para variables categóricas, o en escala de mayor a menor para numéricas.

A continuación se muestran algunas observaciones interesantes obtenidas del análisis:

![División de destinos por planeta de origen](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/destino-homeplanet.png)
- Comparado con otros planetas destino, el planeta origen de los que van a PSO J318.5-22 son casi todos de la Tierra


![Distribución de edades](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/edad.png)
- Hay una caida significativa de viajantes abajo de la edad de adultez, que es de esperarse si los viajantes no adultos requieren ir en grupo con adulto


![Cantidad gastada en cada amenidad por planeta origen](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/gastos-by-homeplanet.png)
- Viajantes de Marte son mas propensos a gastar en servicio de cuarto y en compras en ell Mall, los de Europa en comida rápida y en spa, y los de la Tierra en general gastan menos.


![Cantidad de viajantes en animación suspendida por nivel](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/cryosleep.png)
- La mayoría de los viajantes en animación suspendida estan hospedados en el nivel B, en donde casi todas las habitaciones han sido dedicadas para este propósito.


![Cantidad total gastada por nivel de hospedaje](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/gastos-deck.png)
- Los visitantes que más gastan se encuentran en los niveles A, C y T, que pueden posiblemente ser entonces mas ricos en promedio, mientras que el nivel B es el de menos gastos, lo que tiene sentido como la mayoría de estos están en animación suspendida y por lo tanto son incapaces de usar las amenidades.



![Distribución de planeta origen por componentes principales](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/multivariado.png)
- El planeta orígen queda distribuida de manera relativamente correlada por los componentes principales, aunque no es separable.


![Cantidad de visitantes transportados por nivel de hospedaje](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/transported-deck.png)
- La una significante mayoría de las personas transportadas son de los niveles B y F; notese que aunque la mayoría de los de B estaban en animación suspendida, lo musmo no ocurre con F.


## Modelado

## Implantación

### Reporte
