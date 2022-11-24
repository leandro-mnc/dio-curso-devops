# Curso Devops Dio Carrefour

[Link Curso](https://www.dio.me/bootcamp/cloud-devops-experience-banco-carrefour)

## Criar serviço php apache

```
docker service create --name meu-app --replicas 12 -p 80:80 --mount type=volume,src=app,dst=/app/ -dt webdevops/php-apache:7.2
```

## Replicar arquivos de um nó para o outro

```
mount ip_address:/var/lib/docker/volumes/app/_data /var/lib/docker/volumes/app/_data
```