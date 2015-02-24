#!/usr/bin/env ruby

require "bunny"

conn = Bunny.new("amqp://test:test@172.16.80.182:5672")
conn.start

ch = conn.create_channel
q = ch.queue("hello")

puts "[*] Waiting for message in #{q.name}. To exit press Ctrl+C"
q.subscribe(:block => true) do |delivery_info, properties, body|
  puts "[x] Received #{body}"
  delivery_info.consumer.cancel
end

