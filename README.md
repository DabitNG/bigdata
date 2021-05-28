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

Para levantar el cuaderno de notas Zeppelin:
```
./prepare.sh zeppelin
./launch.sh
```
=> [http://zeppelin.localhost](http://zeppelin.localhost)

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