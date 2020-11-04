FROM nginx:1.18
RUN apt-get update && apt-get install -y curl && apt-get clean
ADD ./start.sh .
RUN chmod +x start.sh
EXPOSE 8080
CMD ["./start.sh"]