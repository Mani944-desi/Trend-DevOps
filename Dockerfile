FROM nginx:alpine

# Copy the built static site from dist/ into nginx html dir
COPY dist/ /usr/share/nginx/html

# nginx listens on port 80 inside the container
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
