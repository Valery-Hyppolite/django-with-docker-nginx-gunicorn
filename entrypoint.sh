#!/bin/sh
python manage.py wait_for_db
python manage.py collectstatic --noinput
python manage.py migrate
gunicorn  productInventory.wsgi:application --bin "0.0.0.0:8000"