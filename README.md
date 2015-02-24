RabbitMQ Test Cases
=============

# Configuration
## install RabbitMQ server on Unbuntu
- $ wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.3.4/rabbitmq-server_3.3.4-1_all.deb
- $ sudo dpkg -i rabbitmq-server_3.3.4-1_all.deb
(user "rabbitmq" is also created)

## start/stop the server(if not running)
- $ sudo invoke-rc.d rabbitmq-server start
- $ sudo rabbitmqctl status
- $ sudo invoke-rc.d rabbitmq-server stop

## create cluster (on single machine, "ubuntu01" is my test VM hostname)
- $ sudo useradd -U -G sudo -s /bin/bash -m rabbitmq && sudo passwd rabbitmq
- logout out and login as "rabbitmq"
- $ RABBITMQ_NODE_PORT=5672 RABBITMQ_NODENAME=rabbit rabbitmq-server -detached
- $ RABBITMQ_NODE_PORT=5673 RABBITMQ_NODENAME=hare rabbitmq-server -detached
- $ rabbitmqctl -n hare stop_app
- $ rabbitmqctl -n hare join_cluster rabbit@ubuntu01 --ram  # ubuntu01 is hostname
- $ rabbitmqctl -n hare start_app
- $ rabbitmqctl -n rabbit|hare cluster_status
```
Cluster status of node rabbit@ubuntu01 ...
[{nodes,[{disc,[rabbit@ubuntu01]},{ram,[hare@ubuntu01]}]},
 {running_nodes,[hare@ubuntu01,rabbit@ubuntu01]},
 {cluster_name,<<"mycluster">>},
 {partitions,[]}]
...done.
```

## create test user
(because existed guest account doens't support connection from remote host)
- $ sudo rabbitmqctl add_user test test
- $ sudo rabbitmqctl set_user_tags test administrator
- $ sudo rabbitmqctl set_permissions test "." "." ".*"

# Test Cases
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

# broadcast
- exchange types available: direct, topic, headers and fanout.
- exchange type = fanout in this example, it broadcasts message to queues.
- $ ruby publihser.rb
```
[x] Sent message no.1
[x] Sent message no.2
[x] Sent message no.3
...
```
- $ ruby subscriber.rb  # start at least 2 subscribers
- subscriber1
```
[*] Waiting for message in amq.gen-FVOFaRbMyH079kE_ffb0eQ. To exit press Ctrl+C
[x] Received message no.1
[x] Done
[x] Received message no.2
[x] Done
[x] Received message no.3
[x] Done
...
```
- subscriber2
```
[*] Waiting for message in amq.gen-FVOFaRbMyH079kE_ffb0eQ. To exit press Ctrl+C
[x] Received message no.1
[x] Done
[x] Received message no.2
[x] Done
[x] Received message no.3
[x] Done
...
```

# (direct)routing
- a message goes to the queues whose binding key exactly matches the routing key of the message.
- $ ruby publisher_routing.rb info # send message with :routing_key => info
```
[x] Sent message no.1
[x] Sent message no.2
[x] Sent message no.3
...
```

- $ ruby subscriber_routing.rb info
```
[*] Waiting for message in amq.gen-FVOFaRbMyH079kE_ffb0eQ. To exit press Ctrl+C
[x] Received message no.1
[x] Done
[x] Received message no.2
[x] Done
[x] Received message no.3
[x] Done
...
```

- $ruby subscriber_routing.rb xxxx
```
[*] Waiting for message in amq.gen-FVOFaRbMyH079kE_ffb0eQ. To exit press Ctrl+C
<no message received>
```

# topic
- direct exchange still has limitations - it can't do routing based on multiple criteria, topic is more flexible
- $ ruby publisher_topic.rb kern.critical
```
[x] Sent message no.1
[x] Sent message no.2
[x] Sent message no.3
...
```

- $ ruby subscriber_topic.rb *.critical
```
[*] Waiting for message in amq.gen-yGwZSw0OSCsZeIrQzkgffA. To exit press Ctrl+C
[x] Received : message no.1
[x] Done
[x] Received : message no.2
[x] Done
[x] Received : message no.3
[x] Done
...
```

- $ ruby subscriber_topic.rb *.somethingelse
```
[*] Waiting for message in amq.gen-yGwZSw0OSCsZeIrQzkgffA. To exit press Ctrl+C
<no message>
```

# RPC
- Use RabbitMQ to build an RPC system: a client and a scalable RPC server
- $ ruby rpc_server.rb
```
[x] Awaiting RPC requests
[x] Received: 832040 = fib(30)
```
- $ ruby rpc_client.rb
```
[x] Requesting fib(30)
[x] Got 832040
```

## queues mirroring(HA)
- working...























