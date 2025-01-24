## How to run

### create .env
### create logs dir with chmod 777
### run docker-compose-prod.yml

### switch user to www-data (change [app] to container name)
```
docker exec -it --user www-data [app] bash
```

### run migration and seeder (for first time, if you already have database this step is unnecessary)
```
php artisan migrate --force
php artisan db:seed
```

### create user (for first time or when you just want to add user)
```
php artisan make:filament-user
```
