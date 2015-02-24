#!/usr/bin/env ruby

require "bunny"

if ARGV.empty?
  abort "Usage: #{$0} [info]|[warning]|[error]"
end

conn = Bunny.new("amqp://test:test@172.16.80.182:5672")
conn.start

ch = conn.create_channel
x = ch.direct("direct_logs")
severity = ARGV.shift || "info"

begin
  (1..1000).each do |item|
    msg = "message no.#{item}"
    x.publish(msg, :routing_key => severity)
    puts "[x] Sent #{msg}"
    sleep 5.0
  end
rescue Interrupt => _
  ch.close
  conn.close
end

ch.close
conn.close
