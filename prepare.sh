# This script generates docker compose stack file with passed as arguments as working services and launches them
# Common vars
dest="./.env"
backup="./.env.backup"

# Log function
log() {
    echo "$1"
    echo "$(date +"%Y-%m-%d %H:%M:%S,%3N") [PREPARE] $1" >> out.txt
}

# Log and execute string argument as command
logAndExe() {
    log "$1"
    eval $1
}

# Move previous .env file if exists
logAndExe "mv $dest $backup"
# Generate new .env file from env.template
logAndExe "cat ./.env.template > $dest"

cmd="docker-compose -f docker-compose.yml"
services='nifi,zeppelin'

for var in "$@"
do
    service=${var,,}
    log "Service: $service"
    if [[ $services == *$service* ]]; then
        logAndExe "cat ./$service/.env >> $dest"
        cmd="$cmd -f ${var,,}/docker-compose.yml"
    else
        log "Unknown service: $service, skipping"
    fi
done

# create docker compose stack file
logAndExe "$cmd config >| docker-compose.stack.yml"

# remove backup
exit 0