# Big Data Stack

Este proyecto permite levantar un stack para el análisis big data en contenedores docker

## Como funciona

1. Ejecuta el fichero ```./preprare.sh [service1, ..., serviceN]```
2. Ejecuta el fichero ```./launch.sh```

## Servicios

- _*Reverse Proxy:*_ Reverse proxy bajo NGINX (Added by default)
- _*Zeppelin:*_ Zeppelin notebook. => [http://zeppelin.localhost](http://zeppelin.localhost)

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
