# frozen_string_literal: true

# Implements a simple producer-consumer pattern.
class ProducerConsumer
  THREADS = 50

  def process
    @queue = SizedQueue.new(THREADS * 2)

    _producer = make_producer_thread
    consumers = Array.new(THREADS) { make_consumer_thread }
    consumers.each(&:join)
  end

  def make_producer_thread
    Thread.new do
      Customer.find_each do |customer|
        @queue << customer
      end
    ensure
      THREADS.times { @queue << :eoq } # end object
    end
  end

  def make_consumer_thread
    Thread.new do
      until (customer = @queue.pop) == :eoq
        MyMailer.with(customer: customer).send
      end
    end
  end
end
