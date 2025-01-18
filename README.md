## for first time install
run this image and bash into it

### run this image (you must create .env on your path first)
```
docker run -d \
-p 80:80 \
-v ${PWD}/.env:/var/www/html/.env:ro \
-v app_envs:/var/www/html/storage/envs \
-v app_logs:/var/www/html/storage/logs \
filament
```

### run migration and seeder
```
php artisan migrate --force
php artisan db:seed
```

### create user
```
php artisan make:filament-user
```
