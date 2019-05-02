---
id: server-installation
title: Server Standalone Installation
sidebar_label: Standalone Installation
---

## Standalone installation

### Download & start
Download the last version of octoshield (contact us to get a valid download link).

Octoshield runs on a JVM and requires java 1.8 or higher, makes sure java is install on your server.

Simply starts your octoshield server with

```bash
export JHIPSTER_SECURITY_AUTHENTICATION_JWT_SECRET=cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 128 | head -n 1 | base64
java -jar /home/ubuntu/octoshield.war >> octoshield.log
```

### Default user

Octoshield will start with a `admin` user and a `admin` password. Change the password after the install using the UI.

### Configuration & properties

Properties can be set in the command line, or using a yaml file. Use the following setup use your yaml file (for ex. `/home/octoshield/octoshield.yml`):
 
 ```bash
java -jar /home/ubuntu/octoshield.war --spring.config.location=classpath:/config/application.yml,classpath:/config/application-prod.yml,file:/home/octoshield/octoshield.yml 
```

The default settings are the following: 

```yaml
spring:
    datasource:
        type: com.zaxxer.hikari.HikariDataSource
        url: jdbc:h2:file:./h2db/db1/octoshield;DB_CLOSE_DELAY=-1
        username: octoshield
        password:
    jpa:
        database-platform: io.github.jhipster.domain.util.FixedH2Dialect
        database: H2

    mail:
        host: xxxxxxxxxxx
        port: 587
        username: xxxxxxxx
        password: xxxxxxxx
        protocol: smtp
        tls: true
        properties.mail.smtp:
            auth: true
            starttls.enable: true
            ssl.trust: smtp.gmail.com

jhipster:
    http:
        version: V_2_0
    security:
        authentication:
            jwt:
                # This token must be encoded using Base64 (you can type `echo 'secret-key'|base64` on your command line)
                base64-secret: <<CHANGE ME!!!!>>
server:
   port: 8080

# extra TLS options:
# server:
#    port: 443
#    ssl:
#        key-store: classpath:config/tls/keystore.p12
#        key-store-password: password
#        key-store-type: PKCS12
#        key-alias: chaos
#        # The ciphers suite enforce the security by deactivating some old and deprecated SSL cipher, this list was tested against SSL Labs (https://www.ssllabs.com/ssltest/)
#        ciphers: TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 ,TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 ,TLS_DHE_RSA_WITH_AES_256_GCM_SHA384 ,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA256,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA,TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA,TLS_RSA_WITH_CAMELLIA_256_CBC_SHA,TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA,TLS_RSA_WITH_CAMELLIA_128_CBC_SHA

```
### Security

Octoshield use JWT token. This value must be changed to a unique random token on base64, for example `cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 128 | head -n 1 | base64 `
It's advised to change this value in your configuration file, or using the following environment:

```bash
    JHIPSTER_SECURITY_AUTHENTICATION_JWT_SECRET=xxxxxxxxxxxx
```
It is **Not** recommended to set this value in the command line.  use the the `JHIPSTER_SECURITY_AUTHENTICATION_JWT_SECRET` environment variable instead. If you really want to pass the value as property, use `    -Djhipster.security.authentication.jwt.base64-secret:xxxxxxxxxx`

This setting must be set. If you don't, you'll get an exception during startup
```
  Caused by: java.lang.IllegalArgumentException: Decode argument cannot be null.
    at io.jsonwebtoken.lang.Assert.notNull(Assert.java:82)
    at io.jsonwebtoken.io.ExceptionPropagatingDecoder.decode(ExceptionPropagatingDecoder.java:19)
    ...
```

### Database
By default, octoshield will use a local database (H2) using file system. This is enough for a few chaos tests and a few hundred of agents. 

The default connection settings can be changed to change the DB file location:

```yaml
spring:
    datasource:
        type: com.zaxxer.hikari.HikariDataSource
        url: jdbc:h2:file:./target/h2db/db1/chaos;DB_CLOSE_DELAY=-1
        username: chaos
        password:
    jpa:
        database-platform: io.github.jhipster.domain.util.FixedH2Dialect
        database: H2
```

Or alternatively in the command line:

```bash
-Dspring.datasource.type=com.zaxxer.hikari.HikariDataSource \
-Dspring.datasource.url=jdbc:h2:file:/home/octoshield/h2db/db1/chaos;DB_CLOSE_DELAY=-1
-Dspring.datasource.username=chaos \
-Dspring.datasource.password= \
-Dspring.jpa.database-platform=io.github.jhipster.domain.util.FixedH2Dialect \
-Dspring.jpa.database=H2
```

If you need to scale beyond, it's easy to switch to a mysql database:

```yaml
spring:
    datasource:
        type: com.zaxxer.hikari.HikariDataSource
        url: jdbc:mysql://localhost:3306/chaos?useUnicode=true&characterEncoding=utf8&useSSL=false
        username: xxx
        password: xxx
    jpa:
        database-platform: org.hibernate.dialect.MySQL5InnoDBDialect
        database: MYSQL
```

### Email
Email setting isn't required to start Octoshield, simply use the default "admin" user. 
See details in the yaml example to setup your smtp account.


### logging
Change log file destination using the `LOG_FILE` environment variable

Please [contact us ](../help.md) for more details.