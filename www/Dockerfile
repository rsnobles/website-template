# Builder, tester and runtime container for local development
FROM taitounited/cypress:3.14-node10
ARG SERVICE_DIR=.

RUN ./install.sh

WORKDIR /service
COPY ${SERVICE_DIR}/*.sh \
     ${SERVICE_DIR}/package.json \
     ${SERVICE_DIR}/package-lock.* \
     /service/
ENV NODE_ENV development
ENV API_ROOT ''
ENV API_URL /api
RUN npm install --loglevel warn

# Install npm libraries on container to speed up builds
COPY ${SERVICE_DIR}/hooks.json \
     ${SERVICE_DIR}/site/package* \
     /service/site/
RUN rm -f /service/site/hooks.json

RUN mkdir -p /build && \
    npm run install-site

# Start development
EXPOSE 8080
CMD ./develop.sh
