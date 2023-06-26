# django-with-docker-nginx-gunicorn
django-docker

# Configure Django with docker, Nginx, and Cerbot for deployment
## If you want to deploy your Django app on an AWS EC2 instance with docker-compose configure with Nginx and Cerbot for SSL, this is for you. 

**Requirements:**
* AWS EC2 running and docker and docker-compose installed
* Domain or subdomain
* docker installed on your local machine
* Django project with live db already configured in setting.py

****NOTE****: No db image or container will be created for this deployment.  

**DOCUMENT LAYOUT**
1. * Create a script to run some Python commands
1. * Create a docker file
1. * create an Nginx configuration file and a docker file
1. * Create a docker-compose file

* **All files for this document are provided above.**
* **All files should be placed in the root of your project folder. Check the screenshot below as an example.**

![image](https://github.com/Valery-Hyppolite/django-with-docker-nginx-gunicorn/assets/83102811/5b97d037-d26a-43a9-ba8e-2e9734b78532)


## Create a script
In your root folder, create a script with the name: **entrypoint.sh**, copy the textt in the entrypoint.sh file provided into yours, then save. This script will run migration, collect your static files, and let Gunicorn start your application. 

![image](https://github.com/Valery-Hyppolite/django-with-docker-nginx-gunicorn/assets/83102811/fe3507be-4eb5-4e43-b437-1c92d40ab7fa)

## Create a docker file
* Create file named Dockerfile and place the configuration text provided in it, then save. 
This docker file will create an **app** directory. In that **app** directory, it will create an env environment, copy your requirement.txt file, entrypoint.sh file, and your Django project.

![image](https://github.com/Valery-Hyppolite/django-with-docker-nginx-gunicorn/assets/83102811/a1ef6ab9-e33f-4721-8ab1-79d3390ce2b1)

You can also create a user for this docker file by uncommenting out the "**useradd**" section. it's not necessary but it is best practice. 


## Create Nginx config file and docker file
* Create a folder in the root directory of your project name it nginx.
* Inside that folder, create a file named: **default.conf** and a docker file named **Dockerfile**
* In the config file, paste the configuration provieded in it.
* Replace anything marked in red rectangles, then save the file.


![image](https://github.com/Valery-Hyppolite/django-with-docker-nginx-gunicorn/assets/83102811/8ce8e6cd-e172-4490-a888-0d90d230521a)


* **Replace ** the **staticfiles** name with your **STATIC_ROOT** file name which you can find under setting.py 
* Leave everything as default.
* The **app/staticfile** is where Nginx will look to find your staticfiles and serve them. This directory will be created inside the nginx dokcer file which we will creating next.

## CREATE DOCKERFILE FOR NGINX
* This docker file copies the default.config file to the nginx container **etc** directory and creates an app/staticfiles file directory for your staticfiles.


![image](https://github.com/Valery-Hyppolite/django-with-docker-nginx-gunicorn/assets/83102811/8fe0b498-7ff8-4bad-84fb-2134f76e767d)

FROM nginx:alpine3.17-slim
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN  mkdir -p /app/staticfiles

## CREATE DOCKER-COMPOSE FILE

This docker file creates 3 services: 
* **django_app** your django app image
* **Nginx** the nginx image 
* **Cerbot** the cerbot image service that will add SSL to your domain


***

* Create a docker-compose file and name it **docker-compose-deploy.yml** and type the configuration below in it.
* Replace anything marked in red rectangles then save the file.

![image](https://github.com/Valery-Hyppolite/django-with-docker-nginx-gunicorn/assets/83102811/0e484991-d599-4561-bd9b-d65675a686c2)

* Change the **staticfiles** name to your **STATIC_ROOT** name file. This is the same staticfiles name you set in the nginx default.conf file.
* add your **domain or subdomain** name and **email address** . This is needed so Cerbot can provide you with an SSL certificate for your domain.
* leave everything else as default and save the file.

## Deployment
* Add your project to GitHub.
* Clone your project to the EC2 instance. Make sure your ec2 instance has docker and docker-compose installed.
* Navigate to your project directory
* Run: docker-compose -f docker-compose-deploy.yml build
* After your images have been built run this command below to run your containers
* RUN: docker compose -f docker-compose-deploy.yml up

* As this command runs you should see all 3 services up and you should get a message of Successful SSL certificate installed by Cerbot.
* if you got an error, please check your configuration file, and make sure everything is correct. make sure your domain or subdomain name and email are typed correctly. 

* If everything went well, exit the containers by typing **CRTL Z OR COMMAND Z**:
* Then RUN: docker compose -f docker-compose-deploy.yml down


***

Now that you have the certification for your domain name, we need to edit the docker-compose-deploy.yml file to add the certificate.

* On the command line, type, **sudo nano docker-compose-deploy.yml**
* Delete everything inside the file, and replace it with the configuration below.
* Add your **domain** name to the place specified in red rectangles and add your **STATIC ROOT **file name again under **location** indicated in red.
* leave everything else as default. 

![image](https://github.com/Valery-Hyppolite/django-with-docker-nginx-gunicorn/assets/83102811/8eb4226c-2c85-4b33-b0c1-ce43257d32a0)

RUN: docker compose -f docker-compose-deploy.yml -d
* This command will run the containers on the background
* Now, paste your domain name into the browser, you should see your app now. 