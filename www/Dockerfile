# Builder, tester and runtime container for local development
# NOTE: npm libraries are installed inside container to speed up build
FROM taitounited/cypress:3.14-node10
ARG SERVICE_DIR=.
WORKDIR /service
COPY ${SERVICE_DIR}/package.json \
     ${SERVICE_DIR}/package-lock.* \
     ${SERVICE_DIR}/.flowconfi* \
     /service/
ENV NODE_ENV development
ENV API_ROOT ''
ENV API_URL /api
RUN npm install --loglevel warn
EXPOSE 8080

# For gatsby-site
COPY ${SERVICE_DIR}/site/package.json \
     ${SERVICE_DIR}/site/package-lock.* \
     /service/site/
RUN cd /service/site && \
    npm install --loglevel warn
CMD cd /service/site && \
    npm install && \
    npm run develop
