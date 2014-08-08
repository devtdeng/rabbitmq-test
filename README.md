rabbitmq-test
=============

# Configuration
## Install RabbitMQ Server on Unbuntu
- $ wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.3.4/rabbitmq-server_3.3.4-1_all.deb
- $ sudo dpkg -i rabbitmq-server_3.3.4-1_all.deb

## Start the server(if not running)
- $ sudo invoke-rc.d rabbitmq-server start

## Create user
(because existed guest account doens't support connection from remote host)
- $ sudo rabbitmqctl add_user test test
- $ sudo rabbitmqctl set_user_tags test administrator
- $ sudo rabbitmqctl set_permissions test ".*" ".*" ".*"

# Test Steps
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
