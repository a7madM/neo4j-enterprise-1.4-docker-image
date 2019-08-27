FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y default-jre
RUN apt-get install -y curl

ENV NEO4J_TARBALL neo4j-enterprise-1.4-unix.tar.gz
ARG NEO4J_URI=http://dist.neo4j.org/neo4j-enterprise-1.4-unix.tar.gz

RUN curl --fail --silent --show-error --location --remote-name ${NEO4J_URI} \
    && tar --extract --file ${NEO4J_TARBALL} --directory /var/lib \
    && mv /var/lib/neo4j-* /var/lib/neo4j \
    && rm ${NEO4J_TARBALL}

WORKDIR /var/lib/neo4j

RUN mv data /data \
    && ln --symbolic /data

VOLUME /data

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
EXPOSE 7474 7473 7687

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["neo4j"]

