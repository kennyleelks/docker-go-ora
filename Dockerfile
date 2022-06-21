FROM golang:1.18

ADD distrib /distrib

ENV VERSION="11.2.0.4.0" \
    POSTFIX="11_2" \
    VER="11.2"

ENV ORACLE_HOME=/usr/lib/oracle/instantclient_$POSTFIX \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/instantclient_$POSTFIX \
    PATH=$PATH:/usr/lib/oracle/instantclient_$POSTFIX

RUN apt-get update && \
    apt-get -y install zip libaio1 && \
    ls /distrib && \
    unzip /distrib/instantclient-basic-linux.x64-$VERSION.zip -d /usr/lib/oracle && \
    unzip /distrib/instantclient-sdk-linux.x64-$VERSION.zip -d /usr/lib/oracle && \
    unzip /distrib/instantclient-sqlplus-linux.x64-$VERSION.zip -d /usr/lib/oracle && \
    rm -rf /distrib

COPY oci8.pc /usr/local/lib/pkgconfig/oci8.pc

# add alias to go so we don't need to provide compilation flags every time
# not needed for 19.3
RUN ln -s $(find $ORACLE_HOME -name 'libclntsh.so.*' | head -n 1) $ORACLE_HOME/libclntsh.so