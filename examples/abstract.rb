# frozen_string_literal: true

# This is a real-world implementation of a producer consumer
# base class which can be subclassed to implement a producer scope
# and a consumer action.
#
# It adds some additional features:
# - It can do verbose logging, including tracking the number of
#   produced/consumed objects.
# - It can retry failed consumer actions.
# - It can be run with a specified number of threads.
# - It can be run in single-threaded mode for debugging.
# - It has a dry-run mode which skips the consumer action.
# - It has before/after/around method hooks.
class AbstractProducerConsumer

  attr_reader :dry_run, :verbose, :threads

  def initialize(threads: nil, verbose: false, dry_run: false)
    @threads = threads || default_threads
    @verbose = verbose
    @dry_run = dry_run
  end

  def process
    before_process
    around_process do
      threads == 0 ? process_sync : process_async
    end
    after_process
    @consumed
  end

  protected

  def around_process
    yield
  end

  def before_process
    # can be overridden
  end

  def after_process
    # can be overridden
  end

  def producer_scope
    raise NotImplementedError.new('Subclass must override #producer_scope')
  end

  def consume(_object)
    raise NotImplementedError.new('Subclass must override #consume')
  end

  def process_sync
    log 'Using single-threaded mode'
    @consumed = producer_scope.each(&method(:consume)).size
  end

  def process_async
    log "Using #{threads} threads"
    consumer_mutex
    @queue = SizedQueue.new(threads * 2)
    @produced = 0
    @consumed = 0

    producer = producer_thread
    consumers = Array.new(threads) { |n| consumer_thread(n) }
    producer.join
    consumers.each(&:join)
    log "All consumers finished C:#{@consumed}"
    @consumed
  end

  def producer_thread
    Thread.new do
      with_retry do
        producer_scope.each do |object|
          @queue << object
          increment_produced
        end
        log "producer.0 finished gracefully P:#{@produced}"
      end
    ensure
      threads.times { @queue << end_object }
    end
  end

  def consumer_thread(index)
    Thread.new do
      with_retry(:consumer, index, attempts: 20) do
        until (object = @queue.pop) == end_object
          consume(object) unless dry_run
          increment_consumed
        end
        log "consumer.#{index} finished gracefully C:#{@produced}"
      end
    end
  end

  def with_retry(type = :producer, index = 0, attempts: 3, delay: 5)
    remaining_attempts = attempts
    begin
      yield
    rescue StandardError => e
      log "#{type}.#{index} error P:#{@produced} C:#{@consumed} - #{e.class} #{e.message.truncate(200)}"
      remaining_attempts -= 1
      if remaining_attempts > 0
        sleep delay
        retry
      end
      log "#{type}.#{index} failed after #{attempts} attempts!"
      raise e
    end
  end

  def increment_produced
    @produced += 1
    log "P:#{@produced}" if @produced % 100 == 0
  end

  def increment_consumed
    consumer_mutex.synchronize do
      @consumed += 1
      log "C:#{@consumed}" if @consumed % 100 == 0
    end
  end

  def consumer_mutex
    @consumer_mutex ||= Mutex.new
  end

  def end_object
    :eoq
  end

  def default_threads
    # multi-threading causes issues when running tests
    Rails.env.test? ? 0 : 5
  end

  def log(msg)
    print "\n#{'[dry] ' if dry_run}Task: #{msg}" if verbose
  end
end
