# stage 1: Build and Dependencies
FROM node:20-alpine AS builder
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

# stage: 2 Final Runtime Image.
FROM node:20-alpine
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY package.json ./
COPY server.js ./

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Inform Docker that the container listens on port 3000 at runtime
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]