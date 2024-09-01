#!/bin/sh

run()
{ 
    # Set correct permissions for fetchmail configuration
    chmod 0600 /data/etc/fetchmailrc
    chown fetchmail:fetchmail /data/etc/
    chown fetchmail:fetchmail /data/etc/fetchmailrc
    
    # Prepare the log file for fetchmail
    touch /data/log/fetchmail.log
    chown fetchmail:fetchmail /data/log/fetchmail.log

    # Run the cron daemon in the background (logrotate will be managed by cron)
    crond
    
    # Continuously output the last 50 lines of the log file to the console
    tail -n 50 -f /data/log/fetchmail.log &
    
    # Run fetchmail as an endless loop with reduced permissions
    su -s /bin/sh -c '/bin/sh /bin/fetchmail_daemon.sh' fetchmail
}

run
