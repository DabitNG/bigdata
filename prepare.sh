# This script generates docker compose stack file with passed as arguments as working services and launches them
# Common vars
backup="./backup"
dest="./.env"
dcs_bckp="./docker-compose.stack.yml"

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
logAndExe "mkdir backup"
logAndExe "mv $dest $backup/$dest.backup"
logAndExe "mv $dc_bckp $backup/$dc_bckp.backup"
logAndExe "mv $dcs_bckp $backup/$dcs_bckp.backup"


# Generate new .env file from env.template
logAndExe "cat ./.env.template > $dest"

cmd="docker-compose -f docker-compose.yml.template"
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

read -n 1 -s -r -p "Press any key to close"
