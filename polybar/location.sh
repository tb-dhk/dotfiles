#!/bin/bash

response=$(curl -s https://ipapi.co/json/)
city=$(echo "$response" | jq -r '.city')
country=$(echo "$response" | jq -r '.country_name')

echo "$city, $country" | tr '[:upper:]' '[:lower:]'
