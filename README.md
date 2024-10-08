# docker-fetchmail

Fork to update fetchmail and provide it as an unraid app.

alpine linux with fetchmail and logrotate

```
docker run -it --name fetchmail -v /fetchmail_config:/data -e TIMECRON:300 patrickstigler/docker-fetchmail
```
TIMECRON: Time to Recheck mail, if nothing set it defaults to 300 seconds (which should accept the most mail servers)

# configuration
create a local `etc/fetchmailrc` file and adjust it to your own needs
 - let the postmaster run as fetchmail
 - use the /data/log/fetchmail.log logging path for correct logrotate interop
example:

```conf
set no syslog
set logfile /data/log/fetchmail.log

set postmaster "fetchmail"

poll imap.gmail.com with proto IMAP
  user 'someusername@gmail.com' there with password 'yourpassword' is fetchmail here options ssl
  smtphost mail.example.org
  smtpname some.user@example.org
```

# docker-compose example
mount the folder, which contains the `etc/fetchmailrc` into the `/data` of the container

```yml
fetchmail:
  restart: always
  image: patrickstigler/docker-fetchmail
  hostname: fetchmail
  volumes:
    - ./fetchmail:/data:rw
  environment:
   - TIMECRON=300
```
The fetchmail container logs directly into the mountpoint `log/fetchmail.log`
