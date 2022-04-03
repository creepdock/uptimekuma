FROM debian:bullseye AS build
WORKDIR /app
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
RUN apt update
RUN apt install git bash sudo curl wget gnupg chromium python3 python3-pip python3-cryptography python3-six python3-yaml python3-click python3-markdown python3-requests python3-requests-oauthlib sqlite3 iputils-ping util-linux dumb-init gnupg -y
RUN pip3 install apprise
RUN echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/ buster main' | sudo tee /etc/apt/sources.list.d/cloudflare-main.list
RUN apt update
RUN apt install cloudflared
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN git clone https://github.com/louislam/uptime-kuma.git .
RUN apt install nodejs -y
RUN npm i
RUN npm i vite -g
RUN npm run build
RUN chmod +x extra/entrypoint.sh

EXPOSE 3001
VOLUME ["/app/data"]
HEALTHCHECK --interval=60s --timeout=30s --start-period=180s --retries=5 CMD node extra/healthcheck.js
ENTRYPOINT ["extra/entrypoint.sh"]
CMD ["node","server/server.js"]
