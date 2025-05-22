### Build stage : focuses on creating the application.
FROM node:22.12.0 AS builder

# Sets /app as the working directory within the container.
WORKDIR /app

#Copies package.json and package-lock.json  from the host to the /app directory in the container.
COPY package*.json ./

# Uses npm to install all dependencies listed in package.json.
RUN npm install

# Copies the rest of the application files (e.g., source code) into the container.
COPY . .

# Build the application ( Compiles the Next.js application.Generates a .next folder containing optimized, production-ready files. )
RUN npm build 

### Run stage :This stage creates a lightweight image containing only the files needed to run the application.
FROM node:22.12.0-bullseye-slim AS runner

# Copies specific directories from the builder stage, These files are all the runner needs to serve the Next.js application.
COPY --from=builder /app/.next/standalone ./standalone
COPY --from=builder /app/public ./standalone/public
COPY --from=builder /app/.next/static ./standalone/.next/static

# Expose the Next.js default port
EXPOSE 3000

# Start the Next.js app
CMD ["node", "./standalone/server.js"]