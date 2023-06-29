#!/bin/bash

source .Yggdrasil.sh-completion.bash
source .env

# Check if Docker was installed 
check_docker_installed() {
    if ! command -v docker &> /dev/null; then
        echo "Error : Docker is not installed."
        exit 1
    fi
}

# Check if docker are running
check_docker_running() {
    if ! docker info &> /dev/null; then
        echo "Error : Docker is not running."
        exit 1
    fi
}

# Launch checking Docker
check_docker_installed
check_docker_running

# Function to display available services
show_available_services() {
    services=$(docker-compose config --services)
    echo "Available services :"
    echo "$services"
}

# Function to start container
start_containers() {
    service_names=("$@")  
    allowed_images=("cracking" "discover" "exploit" "forensics" "osint" "post-exploit" "reporting" "web" "wireless" "all")

    if [ $# -eq 0 ]; then
        echo "Please specify the services you want to start."
        show_available_services
        exit 1
    fi

    if [ $# -eq 1 ]; then
        service_name=$1

        # Check if the service name is in the allowed images list
        if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
            echo "Error: You are not allowed to start the container for service $service_name."
            exit 1
        fi

        if [ "$service_name" = "all" ]; then
            docker-compose up -d
            echo "Every service was started."
        else
            docker-compose up -d "$service_name"
            echo "Service $service_name was started."
        fi
    else
        for service_name in "${service_names[@]}"; do
            # Check if the service name is in the allowed images list
            if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
                echo "Error: You are not allowed to start the container for service $service_name."
                exit 1
            fi

            if [ "$service_name" = "all" ]; then
                docker-compose up -d
                echo "Every service was started."
            else
                docker-compose up -d "$service_name"
                echo "Service $service_name was started."
            fi
        done
    fi
}


# Function to stop container
stop_container() {
    service_names=("$@")  
    allowed_images=("cracking" "discover" "exploit" "forensics" "osint" "post-exploit" "reporting" "web" "wireless" "all")

    if [ $# -eq 0 ]; then
        echo "Please specify the services you want to stop."
        show_available_services
        exit 1
    fi

    if [ $# -eq 1 ]; then
        service_name=$1

        # Check if the service name is in the allowed images list
        if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
            echo "Error: You are not allowed to stop the container for service $service_name."
            exit 1
        fi

        if [ "$service_name" = "all" ]; then
            docker-compose stop
            echo "Every service was stopped."
        else
            docker-compose stop "$service_name"
            echo "Service $service_name was stopped."
        fi
    else
        for service_name in "${service_names[@]}"; do
            # Check if the service name is in the allowed images list
            if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
                echo "Error: You are not allowed to stop the container for service $service_name."
                exit 1
            fi

            if [ "$service_name" = "all" ]; then
                docker-compose stop
                echo "Every service was stopped."
            else
                docker-compose stop "$service_name"
                echo "Service $service_name was stopped."
            fi
        done
    fi
}

#Function to stop and remove 
stoprm_container() {
    service_name=$1
    allowed_images=("cracking" "discover" "exploit" "forensics" "osint" "post-exploit" "reporting" "web" "wireless" "all")
    if [ -z "$service_name" ]; then
        echo "Please specify the service for which you want to remove the container."
        show_available_services
        exit 1
    fi

    # Check if the service name is in the allowed images list
    if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
        echo "Error: You are not allowed to remove the container for service $service_name."
        exit 1
    fi
    if [ "$service_name" = "all" ]; then
        read -p "WARNING: If you remove the container, you'll lose all your data except in shared volumes. Do you want to stop and remove the container? (yes/no): " choice
        if [[ "$choice" == "yes" ]]; then
            docker-compose down
        else
            echo "Aborted."
        fi
    elif [[ -n "$service_name" ]]; then
        read -p "WARNING: If you remove the container, you'll lose all your data except in shared volumes. Do you want to stop and remove the container? (yes/no): " choice
        if [[ "$choice" == "yes" ]]; then
            if ! stop_container "$service_name"; then
                echo "Error: Failed to stop the container, maybe the container hasn't been launched or is already stopped."
            fi
            if ! remove_container "$service_name"; then
                echo "Error: Failed to remove the container, maybe the container wasn't launched at all."
            fi
        else
            echo "Aborted"
        fi
    fi
}

# Function to build container
build_container() {
    service_names=("$@")  
    allowed_images=("cracking" "discover" "exploit" "forensics" "osint" "post-exploit" "reporting" "web" "wireless" "all")

    if [ $# -eq 0 ]; then
        echo "Please specify the services you want to build."
        show_available_services
        exit 1
    fi

    if [ $# -eq 1 ]; then
        service_name=$1

        # Check if the service name is in the allowed images list
        if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
            echo "Error: You are not allowed to build the image for service $service_name."
            exit 1
        fi

        if [ "$service_name" = "all" ]; then
            docker-compose build
            echo "Every service was build."
        else
            docker-compose build "$service_name"
            echo "Service $service_name was built."
        fi
    else
        for service_name in "${service_names[@]}"; do
            # Check if the service name is in the allowed images list
            if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
                echo "Error: You are not allowed to build the image for service $service_name."
                exit 1
            fi

            if [ "$service_name" = "all" ]; then
                docker-compose build
                echo "Every service was build."
            else
                docker-compose build "$service_name"
                echo "Service $service_name was built."
            fi
        done
    fi
}

# Function to display the status of a container
container_status() {
    service_name=$1
    echo ""
    echo "List of containers"
    docker-compose ps $service_name | grep Yggdrasil
    echo ""
    echo "List Of Images"
    docker-compose images

}

# Function to execute a command in a container
exec_command() {
    tool=$1
    shift
    command=$@

    declare -A tool_to_container

    # Read tool mappings from file
    while IFS=':' read -r t c; do
        tool_to_container["$t"]="$c"
    done < "./configuration/tools_conf/tool_mappings.txt"

    if [[ -z "$tool" ]]; then
        echo "No tool specified."
        echo "Usage: ./Yggdrasil.sh exec <tool> <argument>"
        exit 1
    fi

    if [[ -z "${tool_to_container[$tool]}" ]]; then
        echo "Unknown tool."
        exit 1
    fi

    container="${tool_to_container[$tool]}"
    docker-compose exec "$container" "$tool" "$command"
}

manexec_command() {
    service_name=$1
    shift
    command=$@

    docker-compose exec $service_name $command
}

# Function to extract data from a container
extract_data() {
    service_names=("$@")  
    allowed_images=("cracking" "discover" "exploit" "forensics" "osint" "post-exploit" "reporting" "web" "wireless" "all")

    if [ $# -eq 0 ]; then
        echo "Please specify the services you want to extract data."
        show_available_services
        exit 1
    fi

    if [ $# -eq 1 ]; then
        service_name=$1

        # Check if the service name is in the allowed images list
        if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
            echo "Error: You are not allowed to extract data of the service $service_name."
            exit 1
        else 
			docker-compose exec "$service_name" sh -c 'chmod 000 ./* -R && mv ./* /home/kali/Yggdrasil_data'
			echo "data of $service_name extracted, you can find your data in the ${ENVIRO}_$service_name"
		fi
	fi
}

# Function to remove a container
remove_container() {
    service_name=$1
    allowed_images=("cracking" "discover" "exploit" "forensics" "osint" "post-exploit" "reporting" "web" "wireless")
    if [ -z "$service_name" ]; then
        echo "Please specify the service for which you want to remove the container."
        show_available_services
        exit 1
    fi

    # Check if the service name is in the allowed images list
    if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
        echo "Error: You are not allowed to remove the container for service $service_name."
        exit 1
    else
		docker-compose rm -f $service_name
		echo "Container $service_name deleted."
	fi

}

remove-image() {
    service_name=$1
    allowed_images=("cracking" "discover" "exploit" "forensics" "osint" "post-exploit" "reporting" "web" "wireless" "all")
    if [ -z "$service_name" ]; then
        echo "Please specify the service for which you want to remove the image."
        show_available_services
        exit 1
    fi

    # Check if the service name is in the allowed images list
    if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
        echo "Error: You are not allowed to remove the image for service $service_name."
        exit 1
    fi
    
# adding the functionnality to stop, remove all containers and removing all Yggdrasil Images
    if [[ "$service_name" == "all" ]] ;then 
		if ! docker-compose down; then
			echo "Error: Failed to stop services"
		fi
			if ! docker rmi rhacknarok/yggdrasil_exploit_image; then
				echo "The exploit image are note launched or the removing are failed"
			fi
			if ! docker rmi rhacknarok/yggdrasil_post_exploit_image; then
				echo "The post-exploit image are note launched or the removing are failed"
			fi
			if ! docker rmi rhacknarok/yggdrasil_reporting_image; then
				echo "The reporting image are note launched or the removing are failed"
			fi
			if ! docker rmi rhacknarok/yggdrasil_osint_image; then
				echo "The osint image are note launched or the removing are failed"
			fi
			if ! docker rmi rhacknarok/yggdrasil_discover_image; then
				echo "The discover image are note launched or the removing are failed"
			fi
			if ! docker rmi rhacknarok/yggdrasil_web_image; then
				echo "The web image are note launched or the removing are failed"
			fi
			if ! docker rmi rhacknarok/yggdrasil_cracking_image; then
				echo "The cracking image are note launched or the removing are failed"
			fi
			if ! docker rmi rhacknarok/yggdrasil_wireless_image; then
				echo "The wireless image are note launched or the removing are failed"
			fi
			if ! docker rmi rhacknarok/yggdrasil_forensics_image; then
				echo "The forensics image are note launched or the removing are failed"
			fi
	exit 1
	fi
# special name of post-exploit container, because the image have not the same name of the service 
	if [[ "$service_name" == "post-exploit" ]]; then
		if ! docker rmi rhacknarok/yggdrasil_post_exploit_image; then 
			echo "The service is not running or the image does not exist."
			exit 1
		fi
	fi

	if ! docker rmi rhacknarok/yggdrasil_"$service_name"_image; then        
		read -p "The image for service $service_name is used in a container, WARNING: if you force the deletion of images when a container is already using that image, you'll lose all your data except in shared volumes. Do you want to stop and remove the container? (yes/no): " choice
		if [[ "$choice" == "yes" ]]; then
			if ! docker-compose stop "$service_name"; then
				echo "Error: Failed to stop the $service_name container."
			fi
			if ! docker-compose rm -f "$service_name"; then
				echo "Error: Failed to remove the $service_name container."
			fi
			if [[ "$service_name" == "post-exploit" ]]; then
				if ! docker rmi rhacknarok/yggdrasil_post_exploit_image; then
					echo "Error: Failed to remove the $service_name image."
				fi
			else
				if ! docker rmi rhacknarok/yggdrasil_"$service_name"_image; then
					echo "Error: Failed to remove the $service_name image."
				fi
			fi
		else
			echo "Aborted."
		fi
	fi
}


# Function to enter in a container
enter_container() {
    service_name=$1
    allowed_images=("cracking" "discover" "exploit" "forensics" "osint" "post-exploit" "reporting" "web" "wireless")
    if [ -z "$service_name" ]; then
        echo "Please specify the service for which you want to enter in interaction."
        show_available_services
        exit 1
    fi

    # Check if the service name is in the allowed images list
    if [[ ! " ${allowed_images[@]} " =~ " $service_name " ]]; then
        echo "Error: You are not allowed to enter in container $service_name."
        exit 1
    else
		docker-compose exec $service_name /bin/bash
	fi
}
start_record() {
    echo "Recording started."
    echo "if you want to stop the record just make CTRL+D or type exit"
    timestamp=$(date +"%Y%m%d%H%M%S")
    record_file="command_history_${timestamp}.txt"
    script -f -q "$record_file"
}

listtools() {
    tool_type=$1
	if [ -z "$service" ]; then
		echo "please specify the service from which you want to list the tools."
		echo "Usage: ./Yggdrasil.sh list <service>"
        exit 1
    fi
    # Check if the tools file exist
    if [ ! -f "./configuration/tools_conf/tool_descriptions.txt" ]; then
        echo "Description file doesn't exist"
        return 1
    fi

    # Display tools and description
    grep -i "^$tool_type:" "./configuration/tools_conf/tool_descriptions.txt" | awk -F ":" '{sub(/^[^:]+:/, ""); print}'
}

# Function to display use case
show_usage_examples() {
    echo "Use case :"
    echo ""
    echo "Build service :"
    echo "  Yggdrasil.sh build <service>"
    echo ""
    echo "Start service :"
    echo "  Yggdrasil.sh start <service>"
    echo ""
    echo "Stop service :"
    echo "  Yggdrasil.sh stop <service>"
    echo ""
    echo "Stop and remove containers :"
    echo "  Yggdrasil.sh stoprm <service> "
    echo ""
    echo "Display status :"
    echo "  Yggdrasil.sh status <service>"
    echo ""
    echo "List service-related tools :"
    echo "  Yggdrasil.sh list <service>"
    echo ""
    echo "Execute a command :"
    echo "  Yggdrasil.sh exec command"
    echo ""
    echo "Execute a special command specifying the service container (useful for applications not specified in the tool_mapping file) :"
    echo "  Yggdrasil.sh manexec <service> command"
    echo ""
    echo "Enter a service in interactive mode :"
    echo "  Yggdrasil.sh enter <service>"
    echo ""
    echo "Execute a command in a service manually :"
    echo "  Yggdrasil.sh manexec <service> command"
    echo ""
    echo "Start the recording of the terminal to stop it just make CTRL+D or type Exit:"
    echo "  Yggdrasil.sh record"
    echo ""
    echo "Extract data from a service :"
    echo "  Yggdrasil.sh extract <service>"
    echo ""
    echo "Delete a container of service :"
    echo "  Yggdrasil.sh remove <service>"
    echo ""
    echo "Delete image :"
    echo "  Yggdrasil.sh remove-image <service>"
    echo ""
}

# help
help() {
    echo "Help :"
    echo ""
    echo "Usage: Yggdrasil.sh <command> [argument]"
    echo ""
    echo "Available Commands :"
    echo "  build    		build service"
    echo "  start    		Start service"
    echo "  stop     		Stop service"
    echo "  stoprm		Stop and remove containers"
    echo "  status   		Display status"
    echo "  list     		List tools"
    echo "  exec     		Execute a command"
    echo "  manexec  		Execute a command manually"
    echo "  enter    		Enter in a service in interactive mode"
    echo "  record   		Start the recording of the terminal"
    echo "  extract  		Extract data from a service"
    echo "  remove   		Delete a service"
    echo "  remove-image   	Delete images"
    echo "  help     		Display the Help Menu"
    echo ""
    show_usage_examples
}

# Fonction about
about() {
            echo '
          /\
         /  \
        / /\ \  /\
       / /  \ \/  \
      / / /\ \ \/\ \
     / / /  \/\ \ \ \
    / / / /\/ /\ \ \ \
   / / / / / /\ \ \ \ \
  / / / / / /\ \ \ \ \ \
 / /_/ /_/_/__\ \_\ \ \ \
/___/ /________\ \___\ \ \
   / / / /______\_\_____\ \
  / / /____________________\
 / /______________\ \
/____________________\ 
        Yggdrasil       
'
echo "Version : 1.0"
echo "Auteur : Oni-kuki | Rhacknarok"
echo "Contact : oni@disroot.org"

}

# Main Function
main() {
    action=$1
    service=$2
    shift
    
    case $action in
        "start")
	    start_containers "$@"
            ;;
        "stop")
            stop_container "$@"
            ;;
        "build")
            build_container "$@"
            ;;
        "status")
            container_status $service
            ;;
        "list")
            listtools "$service"
            ;;
        "exec")
            tool=$service
            shift 2
            exec_command "$tool" "$@"
            ;;
        "manexec")
            shift 2
            manexec_command $service $@
            ;;
        "extract")
            extract_data $service
            ;;
        "remove")
            remove_container $service
            ;;
	"stoprm")
	    stoprm_container $service
	    ;;
        "remove-image")
            remove-image $service
            ;;
        "enter")
	    enter_container $service
            ;;
        "record")
            start_record
            ;;
        "help")
            help
            ;;
        "about")
            about
            ;;
        *)
            echo "Usage: Yggdrasil.sh <build|start|stop|stoprm|list|status|exec|manexec|record|extract|remove|remove-image|enter|help|about|> <service>"
            ;;
    esac
}

# Main function call
main $@
