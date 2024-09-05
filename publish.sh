#!/bin/sh
docker build -t thompsona93/cts-backend .
docker login
docker push thompsona93/cts-backend