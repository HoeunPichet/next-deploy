# Build stage: focuses on creating the application.
FROM node:20 AS builder

ENV NODE_ENV=production

# Set /app as working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN yarn install

# Copy source files and optional env files
COPY .env* ./
COPY . .

# Build the Next.js application
RUN yarn build

# Run stage: lightweight image for running the app
FROM node:20-bullseye-slim AS runner

# Enable standalone mode support
COPY --from=builder /app/.next/standalone ./standalone
COPY --from=builder /app/public ./standalone/public
COPY --from=builder /app/.next/static ./standalone/.next/static

# Expose the correct port
EXPOSE 3000

# Start the server
CMD ["node", "./standalone/server.js"]