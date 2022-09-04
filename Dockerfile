FROM ubuntu:18.04

WORKDIR /workspace

# Install Git
RUN apt-get update
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

# Clone repository
RUN git clone https://github.com/Keyslam/Dartapp
WORKDIR /workspace/Dartapp

# Temporary checkout
RUN git checkout feature/frontend-react

# Install front-end dependencies
WORKDIR /workspace/Dartapp/Frontend
RUN npm install

# Expose React app
EXPOSE 3000