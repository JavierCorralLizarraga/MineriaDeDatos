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

El objetivo final de este desafío es poder determinar, mediante la información del archivo `train.csv` que tiene toda las variables antes mencionadas, un modelo de clasificación binaria que a los viajeros de `test.csv`, pueda asignarseles la variable `Transported` faltante de manera correcta. A la clasificación dada a todos los viajeros en `test.csv` se dará un formato de pares ID:Transportado.

### Determinación del Criterio de Éxito



### Plan de Proyecto

## Preparación de los Datos

El proceso de preparación de los datos es llevada a cabo en el archivo `main.R`, usando información de los archivos `utils.r` y `clean.r`. En primer lugar el archivo `train.csv` se lee y se guarda a un archivo RDS, en caso de no haberse guardado previamente, y se le da el nombre de variable `titanic_train` Aquí, la función `problems()` no encuentra ninguna filas, indicando que no hay filas desplazadas por falta de comas, de donde el único proceso de limpieza estrictamente necesaria fue la imputación de los datos, que llevamos a cabo usando el paquete `VIM`, que provee una función de imputación por similitud de K-medias. Sin embargo, antes de imputarse, se llevo a cabo ingeniería de características para incrememntar la facilidad de usar las variables e interpretarlas. Para esto, a la variable 'ID' se separó en dos los componentes a cada lado del guión, `grupo` y `id`, que sirve para identificar más fácilmente a viajeros que andaban juntos, como la primera parte registrada en `grupo`es la misma para todos los viajeros que reservaron en un mismo grupo. También, a la variable `Cabin`, que consiste de tres partes separados por diagonal, se separó en sus tres coponentes como variables separadas `deck`, `room_num` y `side`. Adicionalmente, al nombre se separó en su primer nombre `fname` y apellido `lname` ya que viajeros con mismos apellidos similares podrian estar relacionados por familia. Finalmente, se generó una variable nueva `gastos`que suma todos los gastos registrados para cada viajero para más fácil visualización.

## Comprensión de los Datos

## Modelado

## Implantación

### Reporte Ejecutivo
