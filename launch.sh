
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

project=$1
detached=$2
if [ "$project" == "" ]; then
    project="bigdata_stack"
fi
if [ "$detached" != "" ]; then
    detached=" -d"
fi
log "Launching $project"
logAndExe "docker-compose -f docker-compose.stack.yml -p $project up --force-recreate --remove-orphans$detached"

read -n 1 -s -r -p "Press any key to close"
exit 0