#!/usr/bin/env ruby

require "bunny"


conn = Bunny.new("amqp://test:test@172.16.80.182:5672")
conn.start

ch = conn.create_channel
q = ch.queue("hello")

(1..100).each do |x|
  msg = "message no.#{x}"
  q.publish(msg, :persistent => true)
  puts "[x] Sent #{msg}"
  sleep 3.0
end

conn.close
