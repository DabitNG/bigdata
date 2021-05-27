# This script generates docker compose stack file with passed as arguments as working services and launches them
# Common vars
backup="backup"
dest=".env"
dcs_bckp="docker-compose.stack.yml"

# Log function
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S,%3N") [PREPARE] $1"
}

# Log and execute string argument as command
logAndExe() {
    log "$1"
    eval "$1"
}

defineSparkWorkers(){
    log "# Workers: $1"
    i=0
    while [ $i -lt $1 ]
    do
        log "Worker #$i"
        logAndExe "cat ./spark/nginx/spark.conf.template >| ./spark/nginx/spark-wk$i.conf"
        logAndExe "sed -i -e 's/worker/wk$i/g' ./spark/nginx/spark-wk$i.conf"
        logAndExe "cat ./spark/worker-compose.yml.template >| ./spark/docker-compose-wk$i.conf"
        logAndExe "sed -i -e 's/worker/wk$i/g' ./spark/docker-compose-wk$i.conf"
        i=$[$i+1]
    done
}

# Move previous .env file if exists
logAndExe "mkdir backup"
logAndExe "mv $dest $backup/$dest.backup"
logAndExe "mv $dcs_bckp $backup/$dcs_bckp.backup"


# Generate new .env file from env.template
logAndExe "cat ./.env.template > $dest"

cmd="docker-compose -f docker-compose.yml.template"
services='nifi,zeppelin,spark'

for var in "$@"
do
    service=${var,,}
    log "Service: $service"

    if [[ "$service" == *"spark"* ]]; then
        logAndExe "cat ./spark/.env >> $dest"
        cmd="$cmd -f ./spark/docker-compose.yml"

        workers=1
        # TODO implementar lo recibido por parámetro
        defineSparkWorkers "$workers"
        while [ $i -lt $workers ]
        do
            cmd="$cmd -f ./spark/docker-compose-wk$i.yml"
            i=$[$i+1]
        done
    elif [[ $service == *$services* ]]; then
        logAndExe "cat ./$service/.env >> $dest"
        cmd="$cmd -f $service/docker-compose.yml"
    else
        log "Unknown service: $service, skipping"
    fi
done

# create docker compose stack file
logAndExe "$cmd config >| docker-compose.stack.yml"
read -n 1 -s -r -p "$(date +"%Y-%m-%d %H:%M:%S,%3N") [PREPARE] OK. Press any key to close."
