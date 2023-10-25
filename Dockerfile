FROM debian:sid

SHELL ["/bin/bash", "-c"] 
WORKDIR /usr/src
RUN rm -rf /etc/apt/sources.list.d && echo 'deb http://mirrors.ustc.edu.cn/debian sid main contrib non-free non-free-firmware' > /etc/apt/sources.list && apt-get update && \
    apt-get install -y git build-essential cmake m4 automake peg libtool autoconf python3 lcov python3-pip python3-venv python-is-python3 libcapture-tiny-perl libdatetime-perl cron supervisor pkg-config libtimedate-perl

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY cron_jobs /etc/cron.d/cron_jobs
COPY FalkorDB FalkorDB
COPY redis redis
COPY generate_coverage.sh generate_coverage.sh
# RUN git clone https://github.com/redis/redis.git
WORKDIR /usr/src/redis
RUN git checkout 7.2 && make -j 24

WORKDIR /usr/src/FalkorDB
RUN python -m venv venv && source venv/bin/activate
RUN make COV=1 -j 24

RUN crontab /etc/cron.d/cron_jobs
WORKDIR /usr/src

ENV REDIS_ARGS="--protected-mode no"
ENV FALKORDB_ARGS="MAX_QUEUED_QUERIES 25 TIMEOUT 10000 RESULTSET_SIZE 10000"
RUN sed -i 's/branch_coverage = 0/branch_coverage = 1/g' /etc/lcovrc

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
