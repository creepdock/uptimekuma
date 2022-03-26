FROM debian:bullseye

WORKDIR /app
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1

RUN apt update
RUN apt upgrade -y

RUN apt install git bash curl wget gnupg chromium -y --no-install-recommends

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install nodejs npm -y --no-install-recommends
RUN git clone https://github.com/louislam/uptime-kuma.git .
RUN npm i
RUN npm i vite -g

RUN npm run build

RUN chmod +x extra/entrypoint.sh

EXPOSE 3001
VOLUME ["/app/data"]
HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 CMD node extra/healthcheck.js
ENTRYPOINT ["extra/entrypoint.sh"]
CMD ["node","server/server.js"]
