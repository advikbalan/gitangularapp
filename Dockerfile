# Stage 1: Build the Angular application
FROM node:lts-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the Angular application
RUN npm run build 

# Stage 2: Serve the Angular application with Nginx
FROM nginx:stable-alpine3.19-perl

# Copy the build output from the previous stage to the Nginx html directory
COPY --from=build /app/dist/angular-14-example /usr/share/nginx/html

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
