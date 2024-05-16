#!/bin/bash

CONTAINER_NAME="containername"
SERVICE_NAME="srvicename"

while true; do
    if docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" &> /dev/null; then
        if docker exec "$CONTAINER_NAME" systemctl is-active --quiet "$SERVICE_NAME"; then
            echo "Service $SERVICE_NAME is running in container $CONTAINER_NAME"
        else
            docker exec "$CONTAINER_NAME" systemctl start "$SERVICE_NAME"
            sleep 10
            if docker exec "$CONTAINER_NAME" systemctl is-active --quiet "$SERVICE_NAME"; then
                echo "Service $SERVICE_NAME restarted successfully in container $CONTAINER_NAME"
            else
                echo "Failed to restart service $SERVICE_NAME in container $CONTAINER_NAME - Alert!"
                # Add your alert mechanism here
            fi
        fi
    else
        echo "Container $CONTAINER_NAME is not running - Alert!"
        # Add your alert mechanism here
    fi
    sleep 60
done &