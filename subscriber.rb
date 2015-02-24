#!/usr/bin/env ruby

require "bunny"

conn = Bunny.new("amqp://test:test@172.16.80.182:5672")
conn.start

ch = conn.create_channel
x = ch.fanout("logs")
q = ch.queue("", :excluesive => true)
q.bind(x)

puts "[*] Waiting for message in #{q.name}. To exit press Ctrl+C"

begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    puts "[x] Received #{body}"
    # imitate some work
    # sleep body.count(".").to_i
    sleep 5.0
    puts "[x] Done"

    # ch.ack(delivery_info.delivery_tag)
  end
rescue Interrupt => _
  ch.close
  conn.close
end
