#!/usr/bin/env ruby

require "bunny"


conn = Bunny.new("amqp://test:test@172.16.80.182:5672")
conn.start

ch = conn.create_channel
x = ch.fanout("logs")

(1..100).each do |item|
  msg = "message no.#{item}"
  x.publish(msg)
  puts "[x] Sent #{msg}"
  sleep 3.0
end

conn.close
