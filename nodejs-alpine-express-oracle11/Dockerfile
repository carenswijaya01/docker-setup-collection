# Base image
FROM node:20.13-alpine as base

# Install dependencies required for Oracle Instant Client and Sequelize
RUN apk --no-cache add \
    bash \
    curl \
    libaio \
    libnsl \
    rpm2cpio \
    && apk add --no-cache --virtual .build-deps gcc g++ make python3 \
    && rm -rf /var/cache/apk/*

# Set Workdir
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app

# Copy all (exclude by .dockerignore) to /home/node/app
COPY . .

# Convert and extract the Oracle Instant Client RPM package
RUN mv /home/node/app/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /tmp/ && \
    mv /home/node/app/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /tmp/ && \
    cd /tmp && \
    rpm2cpio oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm | cpio -idmv && \
    rpm2cpio oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm | cpio -idmv && \
    mv /tmp/usr/lib/oracle /opt/oracle && \
    rm -rf /tmp/* && \
    ln -s /usr/lib/libnsl.so.3 /opt/oracle/11.2/client64/lib/libnsl.so.1

ENV LD_LIBRARY_PATH=/opt/oracle/11.2/client64/lib:$LD_LIBRARY_PATH

# Install all dependencies
RUN cd /home/node/app && npm install

# *
# * ============= Dev Image Setup =============
# *
FROM base as development
RUN npm install -g nodemon

# Set Non Root User
USER node

# Set permissions to node:node
COPY --chown=node:node . .

# *
# * ============= Prod Image Setup =============
# *
FROM base as production
RUN npm install -g pm2

# Set Non Root User
USER node

# Set permissions to node:node
COPY --chown=node:node . .

# Start single instances using pm2
CMD ["pm2-runtime", "bin/www"]
