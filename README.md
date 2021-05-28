# Big Data Stack

Este proyecto permite levantar un stack para el análisis big data en contenedores docker

## Como funciona

1. Ejecuta el fichero ```./preprare.sh [service1, ..., serviceN]```
2. Ejecuta el fichero ```./launch.sh```

Por ejemplo: para levantar todos los servicios disponibles:
```
./prepare.sh zeppelin nifi
./launch.sh
```

## Servicios

- __*Reverse Proxy:*__ Reverse proxy bajo Nginx
- __*Zeppelin:*__ Zeppelin notebook. => [http://zeppelin.localhost](http://zeppelin.localhost)
- __*NIFI:*__ Flujo de datos. => [http://nifi.localhost](http://nifi.localhost)
- __*Spark:*__ Computación cluster:
  - __*Master:*__ Maestro. [http://spark-master.localhost](http://spark-master.localhost)
  - __*Worker 1:*__ Esclavo 1. [http://spark-wk1.localhost](http://spark-wk1.localhost)

### Nginx Reverse Proxy

Por defecto, se levanta un contenedor de Nginx en toda ejecución. Sim embargo, es posible levantar exclusivamente el servicio de Reverse Proxy sin levantar ningún otro servicio. 
Para ello, ejecutamos: ```./prepare.sh``` y ```./launch.sh```

=> [http://localhost](http://localhost)

### Zeppelin

Para levantar el cuaderno de notas Zeppelin, el método más simple es:
```
./prepare.sh zeppelin
./launch.sh
```
=> [http://zeppelin.localhost](http://zeppelin.localhost)

Esta opción, levanta por defecto el servicio y un contexto spark en local, utilizando un solo núcleo.
Si desea levantar el contexto local de spark en zeppelin con capacidad de uso de todos los núcleos, use la opción:
Para levantar el cuaderno de notas Zeppelin, el método más simple es:
```
./prepare.sh zeppelin=local[*]
./launch.sh
```
=> [http://zeppelin.localhost](http://zeppelin.localhost)
Por el momento, no hay posibilidad de indicar el número de núcleos a usar. Es 1 o todos los disponibles en local.

Por último, puede levantar zeppelin junto con un cluster spark, para ello utilice la opción:
```
./prepare.sh zeppelin=spark spark[=workers]
./launch.sh
```
=> [http://zeppelin.localhost](http://zeppelin.localhost)
Este comando desplegará el cluster spark definido según las reglas del apartado "Spark", y Zeppelin conectado a dicho clúster, por lo que podrá lanzar trabajos contra este clúster.

### NIFI

Para levantar el servicio NIFI:
```
./prepare.sh nifi
./launch.sh
```
=> [http://nifi.localhost](http://nifi.localhost)

### SPARK

Para levantar el servicio Spark, existen varios métodos, el más simple es:
```
./prepare.sh spark
./launch.sh
```
Esto despliega un cluster con un nodo máster, un nodo worker y un nginx para dar acceso al worker:
=> [http://spark-master.localhost](http://spark-master.localhost)
=> [http://spark-wk0.localhost](http://spark-wk0.localhost)

Si desea desplegar múltiples nodos workers en el clúster:

```
./prepare.sh spark[=workers] // where workers is a number of desired workers
./launch.sh
```
Por ejemplo: 
```
./prepare.sh spark=3
./launch.sh
```
=> [http://spark-master.localhost](http://spark-master.localhost)
=> [http://spark-wk0.localhost](http://spark-wk0.localhost)
=> [http://spark-wk1.localhost](http://spark-wk1.localhost)
=> [http://spark-wk2.localhost](http://spark-wk2.localhost)