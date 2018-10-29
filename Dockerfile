FROM openshift/base-centos7

WORKDIR /

RUN yum install openssl curl -y && yum clean all
COPY run.sh /

RUN chmod +x run.sh

USER 1001

ENTRYPOINT [ "./run.sh" ]

