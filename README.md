# Q And A

A tool to show questions to someone (like on an exam, or interview),
and to show the questions with answers to someone else.

There is no authentication or authorization, it has to be done by a reverse proxy.

The two endpoints:
* `/question` to show only the question
* `question_state` to show both the questions and the answers, and also switch to the next question

## Usage:

In production it runs with docker-compose, see `docker-compose.yml.sample`.
It has two containers, one for the app - which has to be built and deployed
to the production host -, and one for Redis.

The two endpoints has to be secured by authentication provided by a reverse proxy.

The questions have to be in text files, and the answers, too,
in `/rails/topics-questions` of the container.

### Questions

The questions can be grouped together in topics. At most 99 topics are supported,
and each topic can have at most 99 answers.

The file names are in the form of `QQ-AA.txt` for the question and `QQ-AA-answer.txt`
for the answers. Both `QQ` and `AA` should be two-digit numbers, starting with `01`, to `99`.

So, the very first question: `01-01.txt` with the answer file `01-01-answer.txt`.

The topics can be increased/decreased by showing the first question of the next topic
or the last question of the previous topic.
Also the UI supports moving a single question back and forth.

## Deployment

### Docker image preparation

The docker image has to be built

```shell
docker build -t q-and-a .
```

And copied to the server (save, copy, load):

```shell
docker save q-and-a -o ~/q-and-a.docker.tar
scp -rp ~/q-and-a.docker.tar $TARGET_HOST:

# and on the server
ssh $TARGET_HOST docker load -i q-and-a.docker.tar
```

### Docker compose preparation

The repository contains a sample `docker-compose.yml`, which has to be modified:

Assuming `/var/lib/q-and-a/` contains the files (or any directory):

```yaml
   volumes:
      - /home/q-and-a/topics-questions:/rails/topics-questions
```

has to be changed to:

```yaml
   volumes:
      - /var/lib/q-and-a:/rails/topics-questions
```

### Apache preparation

Assuming there is a dedicated virtual host for this, like in the file
`/etc/apache2/sites-enabled/100-test-ssl.conf`

```text
<Location "/question">
        ProxyPass "http://localhost:3000/question"
        ProxyPassReverse http://localhost:3000

        AuthType basic
        AuthName "Test Questions"
        AuthUserFile /var/www/test/passwords
        Require user test
</Location>

<Location "/question_state">
        ProxyPass "http://localhost:3000/question_state"
        ProxyPassReverse http://localhost:3000

        AuthType basic
        AuthName "Questions Administration"
        AuthUserFile /var/www/test/passwords
        Require user admin
</Location>


<Location /cable>
        ProxyPass ws://localhost:3000/cable
        ProxyPassReverse ws://localhost:3000/cable
</Location>

ProxyPass "/favicon.ico" http://localhost:3000/favicon.ico
ProxyPass "/assets" http://localhost:3000/assets
ProxyPassReverse "/assets" http://localhost:3000

Redirect "/" "/question"
```

The `/` is redirected to the `/question`. Every relevant URL is redirected
to the app. The `/cable` is handled as a websocket, and it is not secured.

Both `/question` and `/question_state` requires basic authentication,
and `/var/www/test/passwords` stores the passwords.

Setting the passwords for the `admin` (and for the `test`) user - for further
details refer the Apache documentation:

```shell
htpasswd /var/www/test/passwords admin
```

### Starting the app

When the configuration files are set, Apache can be restarted `service apache2 restart`.
The app can be started by the `docker-compose up` command, assuming that in the current
directory there is a `docker-compose.yml` file.
