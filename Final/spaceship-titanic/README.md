## Comprensión del Negocio

### Antecedentes

En el escenario hipotético que plantea este desafía, en el año 2912 el navío espacial *Titanic* llevaba a cabo un viaje a 3 exoplanetas habitables para su colonización cuando se encontró con una anomalía espacio-temporal que transportó la mitad de los pasajeros a una dimensión alterna. Sin embargo, el navío sigue intacto y fue posible recopilar información para algunos respecto a si fueron transportados o no, y los records computacionales han registrado en base de datos una variedad de información de los pasajeros. En concreto, para cada pasajero se conoce lo siguiente:
- `PassengerId`, el número ID de los pasajeros
- `HomePlanet`, el planeta de donde abordaron
- `CryoSleep`, que indica sí viajaron en animación suspendida o no
- `Cabin`, que indica la cabina en que se hospedan, en formato deck/número/lado
- `Destination`, que indica el destino a que debían llegar; `Age`, la edad
- `VIP`, que indica si se pagó extra por VIP
- `RoomService`, `FoodCourt`, `ShoppingMall`, `Spa`, `VRDeck`, son cada una las cantidades de dinero pagadas en estas amenidades respectivos del crucero
- `Name`, el nombre y apellido del pasajero
- `Transported`, que indica si fueron transportados o no. 

### Determinación del Objetivo

El objetivo final de este desafío es poder determinar, mediante la información del archivo `train.csv` que tiene toda las variables antes mencionadas, un modelo de clasificación binaria que a los viajeros de `test.csv`, que presenta toda la información anterior menos `Transported`, pueda asignarseles la variable faltante de manera correcta. A la clasificación dada a todos los viajeros en `test.csv` se dará un formato de pares ID:Transportado.

### Determinación del Criterio de Éxito

En la práctica se probaron varios métodos de modelado distintos, ya ajustados con hiperparámetros mejor optimizados usando grid search, para estos, el criterio de éxito que determina el que se usará se basa en la comparación de la matriz de confusión y de la curva de exito generada al probar los modelos sobre el subconjunto de prueba (esta es distinta al presente en `test.csv`como esta es sobre la que el desafío evalua el resultado y por lo tanto no da el resultado correcto a-priori para evaluarlo, por lo que el subconjunto de prueba es elegido de un 25% predeterminado de `train.csv`). Respecto a la competencia y por las restricciones de tiempo que tiene el equipo, consideramos que un modelo factible podría ser aquel que tenga un accuracy mayor a 70% en la competencia de Kaggle.

### Plan de Proyecto

Nuestro plan de proyecto constaría de aproximadamente 15 horas de trabajo, y consta de cuatro fases.
1. Selección y limpieza de datos con ingeniería manual de características. (3 Horas)
2. Análisis Exploratorio. (3 Horas)
3. Selección de modelo, ajuste de hiperparámetros, evaluación del modelo y reentrenamiento con los datos de test. (6 Horas)
4. Implantación del modelo en un servicio web. (3 Horas)

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
- La una significante mayoría de las personas transportadas son de los niveles B y F; notese que aunque la mayoría de los de B estaban en animación suspendida, lo mismo no ocurre con F.

![image](https://user-images.githubusercontent.com/36738020/172481358-af2bfbe0-e593-471d-8f3e-66fd62930e3c.png)
- Las personas que fueron transportadas viajaban en su mayoría solos o en pareja, las no transportadas viajaban en su mayoría solos, grupos de más de tres personas son atípicos en ambos casos.

![image](https://user-images.githubusercontent.com/36738020/172481925-5fa63abb-23d4-4ef0-a373-747ec1e9e2b8.png)
- Las personas que venían de Europa, eran más propensas en proporción a ser transportadas, mientras que las de la Tierra eran más propensos a no ser transportados, los de Marte están divididos casi igualmente en transportados y no transportados.

![image](https://user-images.githubusercontent.com/36738020/172482773-21ae9fe6-b974-47ee-8483-f83da539c80f.png)
- Las personas que estaban en CryoSleep son más propensas a ser transportadas.

![image](https://user-images.githubusercontent.com/36738020/172482987-f95da69e-6748-4ba9-9829-93131085f867.png)
- Las personas en el lado Starboard de la nave son más propensas a ser transportadas.

![image](https://user-images.githubusercontent.com/36738020/172483421-a40ddc06-3a9d-403b-9bdb-2135b6786933.png)
- Las personas transportadas gastaban menos, esto se lo atribuímos a la relación de que la mayoría estaban en CryoSleep y no gastaban.

![Distribución de Transportados por TSNE](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/tsne.png)

- Comparado con PCA que fue altamente mezclado, la distribución de los transportados por TSNE sí resulta más separado, siendo los transportados más probables de ser parte de conjuntos de puntos periféricos comparados con el agrupamiento central de elementos similares, aunque aun así hay muchos que caen dentro del centro que sí fueron transportados o vice versa.

## Modelado
Para llevar a cabo la decisión de que modelo usar para mejor representación de la variable buscada (Transported), se decidió llevar a cabo cinco técnicas de modelado en Python: Logistic Regresion, K Nearest Neighbors, Random Forest, Boosted Random Forest, y Support Vector Machine (En Python también se llevó a cabo TSNE para el análisis multivariado de la sección anterior pero no se usó como modelo). Para cada una de estas técnicas llevamos a caso un proceso similar: separamos la base de datos en *Feature Matrix* y *Target Vector* (que es Transported), lo separamos en datos de entrenamiento y datos de prueba, y luego para cada modelo Iteramos con el método *Grid Search* para obtener los mejores hiperparámetros de actuerdo con la medida score. Después, comparamos entre todos los modelos óptimos de cada técnica a través de la matriz de confusión para seleccionar el modelo final. Se puede apreciar en la curva ROC que las técnicas de Random Forest, Boosted Forest y Logistic Regression fueron mucho mejores que KNN y SVM, y de estas la mejor fue Random Forest. 

![Curva ROC](https://github.com/JavierCorralLizarraga/MineriaDeDatos/blob/main/Final/spaceship-titanic/img/curve.png)

De aquí, entonces, entrenamos a toda la base de datos de entrenamiento sobre esta técnica con sus respectivos hiperparámetros, siendo este modelo resultante entonces el implementado en Kaggle y en Django.
## Implantación
Utilizamos DJango para montar en un framework de programación web un formulario simple que permite llenar la información de un viajero hipotético y regresa la predicción de si sería transportado o no de acuerdo con el modelo. El modelo final usado fue guardado en un archivo serializable con la librería Pickle, que nos permite también cargarlo directamente en Django ya que todo es código de Python. 
### Reporte
Resultado del modelo en la competencia de Kaggle
![image](https://user-images.githubusercontent.com/36738020/172203096-7e965a82-fb83-489e-a613-8e4982ed31c6.png)

