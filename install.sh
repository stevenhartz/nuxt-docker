#!/bin/bash

read -p "Are you sure continue to initialize Nuxt Project (y/n)?" -n 1 -r
echo    
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi


install_nuxt() {
  local INSTALL_DIRECTORY=src

  # Init a new Nuxt app into a temporary directory
  docker-compose -f docker-compose.yml run --rm --no-deps \
    --user "$(id -u)":"$(id -g)" app \
    npx nuxi init ${INSTALL_DIRECTORY}

  # Set ownership of the temporary directory to the current user
  sudo chown -R "$(id -u)":"$(id -g)" ./${INSTALL_DIRECTORY}

  # Move everything from the temporary directory to the current directory
  mv ${INSTALL_DIRECTORY}/* .

  # Remove the temporary directory
  rm -r ${INSTALL_DIRECTORY}
}

# Copy .env file
if [ ! -f ./.env ]; then
    ln -s .env.dev .env
fi

# Build containers
make build

# Install Nuxt framework
install_nuxt 

# Install packages
docker-compose -f docker-compose.yml run --rm --no-deps \
  --user "$(id -u)":"$(id -g)" app \
  yarn install && yarn cache clean

# Start containers
make up

# Print the final message
echo "The client app has been installed and run on http://localhost:3000"