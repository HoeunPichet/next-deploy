# Build stage: focuses on creating the application.
FROM node:22.12.0 AS builder

# Set /app as working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies — use --verbose if debugging
RUN npm cache clean --force && npm install --verbose

# Copy the rest of the source files
COPY . .

# Build the Next.js application
RUN npm run build

# Run stage: lightweight image for running the app
FROM node:22.12.0-bullseye-slim AS runner

# Enable standalone mode support
COPY --from=builder /app/.next/standalone ./standalone
COPY --from=builder /app/public ./standalone/public
COPY --from=builder /app/.next/static ./standalone/.next/static

# Expose port 3000
EXPOSE 3000

# Start the server
CMD ["node", "./standalone/server.js"]