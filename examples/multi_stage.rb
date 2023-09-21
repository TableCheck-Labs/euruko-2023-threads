# frozen_string_literal: true

# Implements a multi-stage producer-consumer pattern.
class MultiStage
  THREADS = 50

  def process
    @download_queue = SizedQueue.new(THREADS * 2)
    @upload_queue = SizedQueue.new(THREADS * 2)

    _producer = make_download_producer
    producer_consumer = make_upload_producer
    consumers = make_upload_consumers

    producer_consumer.join
    consumers.each(&:join)
  end

  def make_download_producer
    Thread.new do
      MyFtp.get_file_names('/my/directory').each do |file_name|
        @download_queue << file_name
      end
    ensure
      THREADS.times { @download_queue << :eoq }
    end
  end

  # includes download consumers!
  def make_upload_producer
    Thread.new do
      download_consumers = Array.new(THREADS) do
        Thread.new do
          until (file_name = @download_queue.pop) == :eoq
            @upload_queue << MyFtp.download_file(file_name)
          end
        end
      end
      download_consumers.each(&:join)
    ensure
      THREADS.times { @upload_queue << :eoq }
    end
  end

  def make_upload_consumers
    Array.new(THREADS) do
      Thread.new do
        until (file_data = @upload_queue.pop) == :eoq
          Aws::S3.upload(file_data)
        end
      end
    end
  end
end
