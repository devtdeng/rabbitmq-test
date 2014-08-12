#!/usr/bin/env ruby

require "bunny"

if ARGV.empty?
  abort "Usage: #{$0} [info]|[warning]|[error]"
end

conn = Bunny.new("amqp://test:test@172.16.80.181:5672")
conn.start

ch = conn.create_channel
x = ch.direct("direct_logs")
severity = ARGV.shift || "info"

(1..100).each do |item|
  msg = "message no.#{item}"
  x.publish(msg, :routing_key => severity)
  puts "[x] Sent #{msg}"
  sleep 3.0
end

conn.close
