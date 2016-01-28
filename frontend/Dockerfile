FROM node

RUN npm install -g gulp
WORKDIR /app
RUN npm rebuild node-sass
RUN npm install
CMD ["gulp", "watch"]
