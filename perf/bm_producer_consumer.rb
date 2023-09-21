# frozen_string_literal: true

require_relative '../examples/producer_consumer'

# Spoof class
class Customer
  def self.find_each(&block)
    1000.times(&block)
  end
end

# Spoof class
class MyMailer
  def self.with(**_kwargs)
    new
  end

  def send
    sleep 0.01
  end
end

require 'benchmark'

# 1000 customers
# 10 milliseconds per mail
Benchmark.bm do |bm|
  bm.report('single thread') do
    Customer.find_each { |c| MyMailer.with(customer: c).send }
  end

  bm.report('50 threads   ') do
    ProducerConsumer.new.process
  end
end
