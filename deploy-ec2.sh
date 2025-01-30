#!/bin/bash

set -e  # Detiene la ejecución si ocurre un error


STACK_INSTANCES="equipo3-instances"

# Directorios de los archivos YAML

INSTANCES_FILE="Cloudformation-ec2.yaml"

#  Validar sintaxis de los archivos YAML
echo " Validando la sintaxis de los archivos YAML..."
for file in $VPC_FILE $SG_FILE $INSTANCES_FILE; do
    aws cloudformation validate-template --template-body file://$file
    echo " $file es válido."
done

echo ""

#  Crear las instancias EC2
echo " Creando las instancias EC2 ($STACK_INSTANCES)..."
aws cloudformation create-stack --stack-name "$STACK_INSTANCES" --template-body file://$INSTANCES_FILE --capabilities CAPABILITY_NAMED_IAM
aws cloudformation wait stack-create-complete --stack-name "$STACK_INSTANCES"
echo " Instancias EC2 creadas exitosamente."

echo " Infraestructura desplegada con éxito."
