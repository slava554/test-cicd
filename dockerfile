# ---- build stage ----
FROM node:24-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build -- --configuration production --output-path=dist

# ---- runtime stage ----
FROM nginx:1.27-alpine
COPY nginx/angular.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist/browser/ /usr/share/nginx/html/
