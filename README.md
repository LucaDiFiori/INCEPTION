# INCEPTION
This project aims to broaden your knowledge of system administration by using Docker. You will virtualize several Docker images, creating them in your new personal virtual machine.

## Sources
- GitHun
  - https://github.com/Forstman1/inception-42 (recommended)
  - https://github.com/shameleon/inception-42?tab=readme-ov-file
  - https://github.com/hel-kame/inception_vagrant (Inception virtual environment)
- Medium
  - https://medium.com/@imyzf/inception-3979046d90a0
  - https://medium.com/@ssterdev/inception-guide-42-project-part-i-7e3af15eb671 (Part 1)
  - https://medium.com/@ssterdev/inception-42-project-part-ii-19a06962cf3b (Part 2)
  - https://medium.com/edureka/docker-networking-1a7d65e89013 (How Containers Communicate)
- Grademe.fr
  - https://tuto.grademe.fr/inception/#nginx

***
***
# What is a Container?
A Container is a standard unit of software that packages up code and all its dependencies so the application runs quickly and reliably from one computing environment to another.

--> Watch this: [NetworkChuck](https://www.youtube.com/watch?v=eGz9DS-aIeY)

<br>
<br>

***


# What is a Docker Image?
Docker Image is a lightweight executable package that includes everything the application needs to run, including the code, runtime environment, system tools, libraries, and dependencies.

Although it cannot guarantee error-free performance, as the behavior of an application ultimately depends on many factors beyond the image itself, using Docker can reduce the likelihood of unexpected errors.

Docker Image is built from a DOCKERFILE, which is a simple text file that contains a set of instructions for building the image, with each instruction creating a new layer in the image.

<br>
<br>

***

# What is a Dockerfile?
Dockerfile is that SIMPLE TEXT FILE that I mentioned earlier, which contains a set of instructions for building a Docker Image. It specifies the base image to use and then includes a series of commands that automate the process for configuring and building the image, such as installing packages, copying files, and setting environment variables. Each command in the Dockerfile creates a new layer in the image.

Here’s an example of a Dockerfile to make things a little bit clear:
```yaml
# This Specifies the base images for the container
# (in this case, it's the 3.14 version of Alpine)
FROM alpine:3.14

# This Run commands in the container shell,
# and installs the specified packages
# (it will install nginx & openssl,
# and will create the directory "/run/nginx" as well)
RUN apk update && \
    apk add nginx openssl && \
    mkdir -p /run/nginx

# This Copies the contents of "./conf/nginx.conf" on the host
# machine to the "/etc/nginx/http.d/"
# directory inside the container
COPY ./conf/nginx.conf /etc/nginx/http.d/default.conf

# This Specifies the command that will run when the container get started
CMD ["nginx", "-g", "daemon off;"]
```


<br>
<br>

***
# What is a Docker Daemon
A daemon is a background process that runs continuously on a computer, typically without direct user interaction. Daemons are often used to handle system tasks, services, or processes that need to operate autonomously in the background.

The Docker daemon, also known as dockerd, is the core background process that runs on a host machine to manage Docker containers and related resources. It acts as the "brain" of Docker, responsible for executing Docker commands and orchestrating all Docker objects such as containers, images, networks, and volumes.

## Key Roles of the Docker Daemon
**Container Management:** <br>
- Creates, starts, stops, and removes containers.
- Handles container lifecycle events (e.g., restarting containers if configured).

**Image Management:** <br>
- Pulls images from Docker registries like Docker Hub.
- Builds and stores images on the host system.

**Network Management:** <br>
- Configures container networks.
- Creates isolated networks for communication between containers.

**API Listener:** <br>
- Listens for requests sent via the Docker CLI or third-party tools using the Docker API.
- Executes the requested operations and returns responses to the client.

**Resource Allocation:** <br>
- Allocates CPU, memory, and other resources to running containers.
- Manages resource isolation using Linux technologies like cgroups and namespaces.

<br>
<br>

***

# What is a Docker Compose?
Docker Compose is a tool that allows you to define and manage multi-container Docker applications. It uses a YAML file (docker-compose.yml) to configure the services, networks, and volumes needed for your application. With Docker Compose, you can start, stop, and manage all the containers defined in the configuration file with simple commands.

--> Watch this: [NetworkChuck](https://www.youtube.com/watch?v=DM65_JyGxCo)


A Docker Compose has 5 important parts, which are:

## 1. Service Definition
Docker Compose allows you to define multiple services (containers) in a single docker-compose.yml file.

**What is a service?** <br>
A service represents a single container, including all its configuration (e.g., image, ports, environment variables).

**How does it work?** <br>
Each service you define in the docker-compose.yml file corresponds to a container. For example:
```yaml
services:
  app:
    image: myapp:latest
  db:
    image: mysql:latest
```
- The `app` service will create a container from the myapp:latest image.
- The `db` service will create a container from the mysql:latest image.

**Benefit**: <br>
You can define all components of your application (like a web server, database, and caching layer) in one place. This ensures the components run together smoothly.


## 2. Networking
Docker Compose automatically sets up a default network for your services to communicate with each other without any manual configuration.

**Default network**: <br>
Compose creates an isolated network for your application, ensuring the services can communicate securely.

**Service communication**: <br>
Services can reference each other by name. For instance:
```yaml
services:
  web:
    image: nginx:latest
  db:
    image: postgres:latest
```
- The `web` service can connect to the `db` service using db as the hostname.

**Benefit**: <br>
No need to manually set up or configure IPs or network links—Compose handles it automatically.


## 3. Volume Management
Compose makes it easy to **define and share volumes** between services for persistent data storage.

**What is a volume?** <br>
A volume stores data that persists even if the container is stopped or restarted.

**How to configure volumes:** <br>
In the docker-compose.yml file:

```yaml
services:
  db:
    image: postgres:latest
    volumes:
      - db_data:/var/lib/postgresql/data
volumes:
  db_data:
```
- The db_data volume will store database files persistently.

**Benefit**: <br>
Ensures data (e.g., databases or user files) is not lost when containers are restarted.


## 4. Scaling
Docker Compose makes it easy to scale services up or down with a single command.

**How does scaling work?** <br>
You can specify the number of container instances (replicas) for a service. For example:
```bash
docker-compose up --scale web=3
```

## 5. Multi-environment Deployment
Compose allows you to easily configure environments like development, staging, or production.

**Environment-specific configuration:** <br>
Use override files or environment files to define different settings. For example:<br>
`docker-compose.override.yml`:
```yaml
services:
  web:
    build:
      context: .
      args:
        ENV: development
```

**Environment variables:** <br>
You can load environment-specific variables from a .env file:
```yaml
services:
  app:
    image: myapp:latest
    environment:
      - ENV=${APP_ENV}
```

Define the value in a .env file:
```bash
APP_ENV=production
```

**Benefit**: <br>
Simplifies deployment by allowing the same docker-compose.yml to be reused across environments.

<br>

# Example
Here’s an example of a Docker Compose to make things a little bit clear:
```yaml
version: '3'

# All the services that you will work with should be declared under
# the SERVICES section!
services:

  # Name of the first service (for example: nginx)
  nginx:
  
    # The hostname of the service (will be the same as the service name!)
    hostname: nginx
    
    # Where the service exist (path) so you can build it (using a Dockerfile)
    build:
      context: ./requirements/nginx
      dockerfile: Dockerfile
      
    # Restart to always keep the service restarting in case of
    # any unexpected errors causing it to go down
    restart: always
    
    # This line explains itself!!!
    depends_on:
      - wordpress
      
    # The ports that will be exposed and you will work with
    ports:
      - 443:443
      
    # The volumes that you will be mounted when the container gets built
    volumes:
      - wordpress:/var/www/html
      
    # The networks that the container will connect and communicate
    # with the other containers
    networks:
      - web

  # Name of the second service (for example: db)
  db:
    etc...
```
- `version`: Specifies the version of the Docker Compose file format.
- `services`: Lists the containers to be run. Each service has its own configuration:
- `volumes`: Specifies volumes for persistent storage.

<br>
<br>

***







***
***
# Usefull Command - Docker
- Pull an immage from docker hub
```bash
docker pull <img>
```
- This command runs a command in a new container, pulling the image if needed and starting the container.
```bash
docker run <img-name>
```
- Delete an immage. Use `-f` after `rmi` if needed
```bash
docker rmi  <img-name>
```

- remove all stopped containers
```bash
docker container prune [OPTIONS]
```

<br>

***
# Usefull Command - Docker Compose
**Start Services:**
```bash
docker-compose up
```
Use `-d` for detached mode:


**Stop Services:**
```bash
docker-compose down
```


**View Logs:**
```bash
docker-compose logs
```


**Scale a Service:**
```bash
docker-compose up --scale web=3
```


**Rebuild Services:**
```bash
docker-compose up --build
```
