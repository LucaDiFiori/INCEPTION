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

# What is a Docker Image?
Docker Image is a lightweight executable package that includes everything the application needs to run, including the code, runtime environment, system tools, libraries, and dependencies.

Although it cannot guarantee error-free performance, as the behavior of an application ultimately depends on many factors beyond the image itself, using Docker can reduce the likelihood of unexpected errors.

Docker Image is built from a DOCKERFILE, which is a simple text file that contains a set of instructions for building the image, with each instruction creating a new layer in the image.

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
