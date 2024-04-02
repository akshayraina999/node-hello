# Stage 1: Build the application
FROM node:18.16.0 

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the Prisma schema and run prisma generate
#COPY prisma/ ./prisma/

#RUN npx prisma generate


# # Create log directory and set permissions
# RUN mkdir -p /var/log/mox/ && chown -R node:node /var/log/mox/

# Copy the rest of the application code
COPY . .

# Set permissions
# RUN chown -R node:node /app
# USER node

# Increase inotify watches
#RUN echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && sysctl -p

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]
