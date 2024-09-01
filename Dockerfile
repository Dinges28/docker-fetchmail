FROM alpine:latest

# Install necessary packages
RUN apk update && \
    apk upgrade && \
    apk add fetchmail openssl logrotate crond

# Set workdir
WORKDIR /data

# Setup fetchmail permissions
RUN chown fetchmail:fetchmail /data && \
    chmod 0744 /data 

# Add logrotate configuration for fetchmail
ADD etc/logrotate.d/fetchmail /etc/logrotate.d/fetchmail

# Add startup script and fetchmail daemon script
ADD start.sh /bin/start.sh
ADD fetchmail_daemon.sh /bin/fetchmail_daemon.sh

# Copy sample fetchmail configuration
COPY fetchmailrc /data/etc/sample/fetchmailrc.sample

# Set the startup script rights
RUN chmod 0700 /bin/start.sh && \
    chown fetchmail:fetchmail /bin/fetchmail_daemon.sh

# Expose volume for data
VOLUME ["/data"]

# Start cron service and fetchmail
CMD ["sh", "-c", "crond && /bin/sh /bin/start.sh"]
