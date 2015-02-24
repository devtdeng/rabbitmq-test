#!/usr/bin/env ruby

require "bunny"

if ARGV.empty?
  abort "Usage: #{$0} [info] [warning] [error]"
end

conn = Bunny.new("amqp://test:test@172.16.80.182:5672")
conn.start

ch = conn.create_channel
x = ch.direct("direct_logs")
q = ch.queue("", :excluesive => true, :auto_delete => true)
ARGV.each do |severity|
  q.bind(x, :routing_key => severity)
end

puts "[*] Waiting for message in #{q.name}. To exit press Ctrl+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts "[x] Received #{body}"
    # imitate some work
    # sleep body.count(".").to_i
    sleep 5.0
    puts "[x] Done"

    # ch.ack(delivery_info.delivery_tag)  # don't close channel here
  end
rescue Interrupt => _
  ch.close
  conn.close
end

ch.close
conn.close
