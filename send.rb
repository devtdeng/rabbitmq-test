#!/usr/bin/env ruby

require "bunny"

conn = Bunny.new("amqp://test:test@172.16.80.182:5672")
conn.start

ch = conn.create_channel
q = ch.queue("hello")
ch.default_exchange.publish("Hello World!", :routing_key => q.name)
puts "[x] Sent 'Hello Wrold!'"

conn.close
