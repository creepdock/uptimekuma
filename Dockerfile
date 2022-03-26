FROM debian:bullseye AS build
WORKDIR /app
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
RUN apt update
RUN apt install git bash curl wget gnupg chromium -y --no-recommends
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN git clone https://github.com/louislam/uptime-kuma.git .
RUN apt install nodejs -y --no-recommends
RUN npm i
RUN npm i vite -g
RUN npm run build
RUN chmod +x extra/entrypoint.sh

EXPOSE 3001
VOLUME ["/app/data"]
HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 CMD node extra/healthcheck.js
ENTRYPOINT ["extra/entrypoint.sh"]
CMD ["node","server/server.js"]
