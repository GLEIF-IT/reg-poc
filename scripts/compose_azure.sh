# see https://learn.microsoft.com/en-us/azure/container-instances/tutorial-docker-compose

# Some useful reminders:
az acr login --name RegPocTest
docker buildx create --use
docker context ls
docker context use myacicontext
docker-compose -f docker-compose-azure.yml push
docker-compose -f docker-compose-azure.yml up --build -d
docker ps
docker-compose -f docker-compose-azure.yml down