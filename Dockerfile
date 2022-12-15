FROM api7/apisix-base:dev

ARG APISIX_VERSION=2.15.1
ENV APISIX_VERSION=${APISIX_VERSION}

ENV DEBIAN_FRONTEND noninteractive

# Dependencies where found in
# https://github.com/apache/apisix-docker/blob/release/apisix-2.15.1/debian-dev/Dockerfile
# https://github.com/apache/apisix/blob/2.15.1/ci/common.sh#L130
RUN set -x \
    && apt-get -y update --fix-missing \
    && apt-get install -y curl \
        gawk \
        git \
        libldap2-dev \
        liblua5.1-0-dev \
        lua5.1 \
        make \
        sudo \
        unzip \
        wget \
        cpanminus \
        build-essential \
        libncurses5-dev \
        libreadline-dev \
        libssl-dev \
        perl \
        libpcre3 \
        libpcre3-dev \
        libldap2-dev \
    && curl "https://raw.githubusercontent.com/apache/apisix/${APISIX_VERSION}/utils/install-dependencies.sh" -sL | bash - \
    && curl "https://raw.githubusercontent.com/apache/apisix/${APISIX_VERSION}/utils/linux-install-etcd-client.sh" -sL | bash - \
    && cpanm --notest "Test::Nginx" "IPC::Run"

# Clone the repository and update submodule's
RUN git clone --depth 1 --branch "${APISIX_VERSION}" "https://github.com/apache/apisix.git" "/usr/local/apisix-plugin-test" \
	&& cd "/usr/local/apisix-plugin-test" \
    && git submodule update --init --recursive

WORKDIR /usr/local/apisix-plugin-test

# Install Dependencies and create log directory
RUN make deps \
    && mkdir logs

ENV TEST_NGINX_BINARY="/usr/local/openresty/bin/openresty"

# Ensure we use the remote etcd
ENV ETCD_VERSION="3.4.15" \
    ETCD_HOST="etcd" \
    ETCDCTL_ENDPOINTS="http://etcd:2379" \
    ENABLE_LOCAL_DNS=true

# Replace hardcoded etcd locations
RUN set +x \
    && sed -i 's~127.0.0.1:2379~etcd:2379~g' ./conf/config-default.yaml \
    && sed -i 's~127.0.0.1:2379~etcd:2379~g' ./t/**/*.t
#    && sed -i 's~127.0.0.1:2379~etcd:2379~g' ./t/**/*.sh

# Copy Plugin code and tests
COPY ./apisix ./apisix
COPY ./t ./t

# Install the plugin into apisix
RUN make install \
    && ./bin/apisix test

ENV FLUSH_ETCD=1

RUN printf '#!/bin/sh \n\
set -ex \n\
./bin/apisix init \n\
./bin/apisix init_etcd \n\
prove -Itest-nginx/lib -I./ -r "$@" \n\
' > /run-tests.sh \
    && chmod +x /run-tests.sh

ENTRYPOINT ["/run-tests.sh"]

CMD [ "t/demo" ]
