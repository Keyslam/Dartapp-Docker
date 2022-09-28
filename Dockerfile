FROM ubuntu:22.04

WORKDIR /workspace

# Update
RUN apt-get update

# Install Git
RUN apt-get install git -y

# Install NPM
ENV NODE_VERSION=16.13.0
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Install .NET 6
RUN apt-get install -y dotnet6

# Install MySQL
RUN apt-get install -y mysql-server

# Clone repository (Don't cache)
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN git clone https://github.com/Keyslam/Dartapp
WORKDIR /workspace/Dartapp
RUN git pull

# Temporary checkout
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN git checkout feature/database

# Setup database
WORKDIR /workspace/Dartapp/Database

# Install front-end dependencies
WORKDIR /workspace/Dartapp/Frontend
RUN npm install

# Install back-end dependencies
WORKDIR /workspace/Dartapp/Backend
RUN dotnet restore

# Expose React app
EXPOSE 3000