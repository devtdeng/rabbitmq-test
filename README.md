RabbitMQ Test Cases
=============

# Configuration
## install RabbitMQ server on Unbuntu
- $ wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.3.4/rabbitmq-server_3.3.4-1_all.deb
- $ sudo dpkg -i rabbitmq-server_3.3.4-1_all.deb

## start the server(if not running)
- $ sudo invoke-rc.d rabbitmq-server start

## create user
(because existed guest account doens't support connection from remote host)
- $ sudo rabbitmqctl add_user test test
- $ sudo rabbitmqctl set_user_tags test administrator
- $ sudo rabbitmqctl set_permissions test ".*" ".*" ".*"

# Test Steps
## sender and receiver
- replace your server host/ip in *.rb files
- $ gem install bunny
- $ ruby send.rb
```
[x] Sent 'Hello Wrold!'
```
- $ ruby receive.rb
```
[*] Waiting for message in hello. To exit press Ctrl+C
[x] Received Hello World!
```

# work queues
- $ ruby new_task.rb
```
[x] Sent message no.1
[x] Sent message no.2
[x] Sent message no.3
...
```
- $ ruby worker.rb  # start at least 2 workers
- e.g worker1
```
[x] Received message no.1
[x] Done
[x] Received message no.3
[x] Done
```
- e.g worker2
```
[x] Received message no.2
[x] Done
[x] Received message no.4
[x] Done
```

# publish/subscribe/exchange
