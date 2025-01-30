#!/bin/bash

set -e  # Detiene la ejecución si ocurre un error

STACK_VPC="equipo3-vpc"
STACK_SG="equipo3-security-groups"
STACK_INSTANCES="equipo3-instances"

# Directorios de los archivos YAML
VPC_FILE="Cloudformation-vpc.yaml"
SG_FILE="Cloudformation-sg.yaml"
INSTANCES_FILE="Cloudformation-ec2.yaml"

#  Validar sintaxis de los archivos YAML
echo " Validando la sintaxis de los archivos YAML..."
for file in $VPC_FILE $SG_FILE $INSTANCES_FILE; do
    aws cloudformation validate-template --template-body file://$file
    echo " $file es válido."
done

echo ""

#  Crear la VPC
echo " Creando la VPC ($STACK_VPC)..."
aws cloudformation create-stack --stack-name "$STACK_VPC" --template-body file://$VPC_FILE --capabilities CAPABILITY_NAMED_IAM
aws cloudformation wait stack-create-complete --stack-name "$STACK_VPC"
echo " VPC creada exitosamente."

echo ""

#  Crear los Security Groups
echo " Creando los Security Groups ($STACK_SG)..."
aws cloudformation create-stack --stack-name "$STACK_SG" --template-body file://$SG_FILE --capabilities CAPABILITY_NAMED_IAM
aws cloudformation wait stack-create-complete --stack-name "$STACK_SG"
echo " Security Groups creados exitosamente."

echo ""

#  Crear las instancias EC2
echo " Creando las instancias EC2 ($STACK_INSTANCES)..."
aws cloudformation create-stack --stack-name "$STACK_INSTANCES" --template-body file://$INSTANCES_FILE --capabilities CAPABILITY_NAMED_IAM
aws cloudformation wait stack-create-complete --stack-name "$STACK_INSTANCES"
echo " Instancias EC2 creadas exitosamente."

echo " Infraestructura desplegada con éxito."
