#!/bin/bash

echo -e '\nWelcome to the salon shop\n'
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"


SERVICES=$($PSQL "SELECT * FROM services")
echo "$SERVICES" | while read SERVICE_ID bar SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done

echo -e "\nPlease enter a service id:"
read SERVICE_ID_SELECTED

if [[ $SERVICE_ID_SELECTED =~ ^[0-9]+* ]]
then 
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
fi

while [[ -z $SERVICE_NAME ]]
do
  SERVICES=$($PSQL "SELECT * FROM services")
echo "$SERVICES" | while read SERVICE_ID bar SERVICE_NAME
do
  echo "$SERVICE_ID) $SERVICE_NAME"
done
echo -e "\nPlease enter a service id:"
read SERVICE_ID_SELECTED
if [[ $SERVICE_ID_SELECTED =~ ^[0-9]+* ]]
then 
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
fi
done

echo -e "\nPlease enter your phone number:"
read CUSTOMER_PHONE

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_ID ]]
then
  echo -e "\nPlease enter your name:"
  read CUSTOMER_NAME
  ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
fi

echo -e "\nPlease enter a service time:"
read SERVICE_TIME

APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
if [[ $APPOINTMENT_RESULT == "INSERT 0 1" ]]
then
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
fi