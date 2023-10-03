FROM node:14
# Setting the working directory in the container
WORKDIR /app
# Copying package.json and package-lock.json to the working directory
COPY package*.json ./
# Installing app dependencies
RUN npm install
# Copying the rest of the application source code
COPY . .
# Exposing the port that the app will be running on
EXPOSE 3000
# Defining the command to run your application
CMD ["npm", "start"]
