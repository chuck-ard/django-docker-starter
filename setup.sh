#!/bin/bash
 
function args()
{
    options=$(getopt -o dv --long help --long debug --long name: -- "$@")
    [ $? -eq 0 ] || {
        echo "Incorrect option provided"
        print_help
        exit 1
    }
    eval set -- "$options"
    while true; do
        case "$1" in
        -v)
            VERBOSE=1
            ;;
        -d)
            DEBUG=1
            ;;
        --debug)
            DEBUG=1
            ;;
        --help)
            print_help
            ;;
        --name)
            shift; # The arg is next in position args
            NAME=$1
            ;;
        --)
            shift
            break
            ;;
        esac
        shift
    done
}

function print_help()
{
    echo "--name \"PROJECT TITLE\""
    echo "-v [VERBOSE]"
}

function create_venv()
{
    python3 -m venv venv && \
    source venv/bin/activate && \
    pip install -r initial_requirements.txt
}

function create_project()
{
    django-admin startproject $NAME
    deactivate
}
 
function cleanup()
{
    sed -i "s/TESTPROJ/${NAME}/g" Dockerfile
    sed -i "s/TESTPROJ/${NAME}/g" docker-compose.yml
    rm initial_requirements.txt
}

if [ "${#@}" -gt 0 ]; then
    args $0 "$@"
else
    print_help
fi
 
if [ -n "$NAME" ]; then
    create_venv;
    create_project;
    cleanup;
fi

