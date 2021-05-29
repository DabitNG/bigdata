# This script generates docker compose stack file with passed as arguments as working services and launches them
# Common vars
backup="backup"
dest=".env"
dcs_bckp="docker-compose.stack.yml"

# Log function
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S,%3N") [PREPARE] $1"
    echo "$(date +"%Y-%m-%d %H:%M:%S,%3N") [PREPARE] $1" >> out.log
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
        log "Generating Worker #$i..."
        logAndExe "cat ./spark/nginx/spark.conf.template >| ./spark/nginx/spark-wk$i.conf"
        logAndExe "sed -i -e 's/worker/wk$i/g' ./spark/nginx/spark-wk$i.conf"
        logAndExe "cat ./spark/worker.yml.template >| ./spark/docker-compose-wk$i.yml"
        logAndExe "sed -i -e 's/-worker/-wk$i/g' ./spark/docker-compose-wk$i.yml"
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
services="nifi,zeppelin,spark"

for var in "$@"
do
    service=${var,,}
    log "Service: $service"

    if [[ "$service" == *"spark"* ]]; then          # Spark service request
        logAndExe "cat ./spark/.env >> $dest"
        workers=1                                   # default worker nodes
        
        if [[ "$service" == *"="* ]]; then          # Get worker nodes
            read workers <<<${service//[^0-9]/ }
        fi

        if [[ $workers < 1 ]]; then                # Check if no worker
            workders=1
        fi

        defineSparkWorkers "$workers"               # Generate workers conf

        log "Generating spark stack..."

        sparkstack="docker-compose -f ./spark/docker-compose.yml"

        i=0
        while [ $i -lt $workers ]                   # Foreach worker add compose file to sparkstack
        do
            sparkstack="$sparkstack -f ./spark/docker-compose-wk$i.yml"
            i=$[$i+1]
        done
        echo "$sparkstack"
        logAndExe "$sparkstack config >| ./spark/docker-compose.stack.yml"
        
        cmd="$cmd -f ./spark/docker-compose.stack.yml"
        echo "$cmd"
        i=0
        while [ $i -lt $workers ]                   # Foreach worker add compose file to sparkstack
        do
            logAndExe "rm ./spark/docker-compose-wk$i.yml"
            i=$[$i+1]
        done       
    elif [[ "${service#$services}" == "$service" ]]; then
        logAndExe "cat ./$service/.env >> $dest"
        cmd="$cmd -f $service/docker-compose.yml"
    else
        log "Unknown service: $service, skipping"
    fi
done

# create docker compose stack file
logAndExe "$cmd config >| docker-compose.stack.yml"
read -n 1 -s -r -p "$(date +"%Y-%m-%d %H:%M:%S,%3N") [PREPARE] OK. Press any key to close."
