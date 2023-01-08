# Image
FROM node:lts-alpine

# Specify the host variable
ENV HOST=0.0.0.0
ENV PORT=3000

# Set up the working directory
WORKDIR /var/www/html

COPY . .

# Update dependencies
RUN apk update \
# Install git
    && apk add --no-cache git \
# Install nuxi package
    && npm install -g nuxi

# Expose the Nuxt port
EXPOSE 3000

# Export the Vite websocket port
EXPOSE 24679

# Run the Nuxt service
CMD ["yarn", "dev", "-o"]