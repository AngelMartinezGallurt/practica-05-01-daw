#!/bin/bash
set -x

# Deshabilitamos la paginación de la salida de los comandos de AWS CLI
# Referencia: https://docs.aws.amazon.com/es_es/cli/latest/userguide/cliv2-migration.html#cliv2-migration-output-pager
export AWS_PAGER=""

source .env

# Obtenemos los identificadores de las instancias de frontend y backend
EC2_ID_FRONTEND=$(aws ec2 describe-instances \
                --filters "Name=tag:Name,Values=$INSTANCE_NAME_FRONTEND" \
                --query "Reservations[*].Instances[*].InstanceId" \
                --output text)

EC2_ID_BACKEND=$(aws ec2 describe-instances \
                --filters "Name=tag:Name,Values=$INSTANCE_NAME_BACKEND" \
                --query "Reservations[*].Instances[*].InstanceId" \
                --output text)

# Eliminamos las intancias de frontend y backend
aws ec2 terminate-instances \
    --instance-ids $EC2_ID_FRONTEND $EC2_ID_BACKEND
