# This script generates docker compose stack file with passed as arguments as working services and launches them
env="./.env"

cat template.env >| $env
cmd="docker-compose -f docker-compose.yml"
for var in "$@"
do
    service=${var,,}
    echo "$service requested"
    case $service in
        "zeppelin")
            echo "Adding $service env vars"
            cat "./$service/.env" >> $env
        ;;
        *)
            echo "Servicio no soportado. Finalizando"
            exit 1
        ;;
    esac
    cmd="$cmd -f ${var,,}/docker-compose.yml"
done
cmd="$cmd config >| docker-compose.stack.yml"
echo $cmd >| out.txt
eval $cmd

# cmd="docker-compose -f docker-compose.stack.yml -p bigdata_stack up --force-recreate"
# eval $cmd