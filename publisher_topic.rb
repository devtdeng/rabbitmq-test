#!/usr/bin/env ruby

require "bunny"

if ARGV.empty?
  abort "Usage: #{$0} [routing_key list]"
end

conn = Bunny.new("amqp://test:test@172.16.80.181:5672")
conn.start

ch = conn.create_channel
x = ch.topic("topic_logs")
severity = ARGV.shift

(1..100).each do |item|
  msg = "message no.#{item}#{}"
  x.publish(msg, :routing_key => severity)
  puts "[x] Sent #{msg}"
  sleep 3.0
end

conn.close
