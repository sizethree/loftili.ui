FROM dadleyy/buildr
MAINTAINER Danny Hadley <dadley@sizethreestudios.com>
COPY . /download/app
CMD (cd /download/app && npm install && bower install --allow-root && grunt release && grunt publish)
