FROM nginx:1.18
MAINTAINER tim.fairweather@arctiq.ca
RUN apt-get update && apt-get install -y curl && apt-get clean
COPY . /usr/share/nginx/html
ADD startup.sh .
RUN chmod +x startup.sh
EXPOSE 8080
CMD ["./startup.sh"]