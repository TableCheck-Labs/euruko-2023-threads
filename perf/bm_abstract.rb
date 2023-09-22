# frozen_string_literal: true

require_relative '../examples/abstract'

# Spoof class
class Customer
  def self.find_each
    1000.times
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

# Specific implementation of abstract parent class.
class MyProducerConsumer < AbstractProducerConsumer

  private

  def producer_scope
    Customer.find_each
  end

  def consume(object)
    MyMailer.with(customer: object).send
  end
end

require 'benchmark'
verbose = true

# 1000 customers
# 10 milliseconds per mail
Benchmark.bm do |bm|
  bm.report('single thread') do
    MyProducerConsumer.new(threads: 1, verbose: verbose).process
  end

  bm.report('50 threads   ') do
    MyProducerConsumer.new(threads: 50, verbose: verbose).process
  end
end
