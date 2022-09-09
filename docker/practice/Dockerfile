FROM nginx

RUN echo "This is build phase"

COPY . /app

RUN sed -i 's+/usr/share/nginx/html+/app+g' /etc/nginx/conf.d/default.conf

# CMD [ "echo", "This is in run phase" ]
# CMD ["sh", "/app/shell01.sh"]
