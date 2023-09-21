# frozen_string_literal: true

require_relative '../examples/multi_stage'

# Spoof class
class MyFtp
  class << self
    def get_file_names(_path)
      Array.new(1000) { :dummy }
    end

    def download_file(_path)
      sleep 0.01
    end
  end
end

# Spoof class
class Aws
  class S3
    class << self
      def upload(_path)
        sleep 0.01
      end
    end
  end
end

require 'benchmark'

# 1000 files
# 10 milliseconds per upload/download
Benchmark.bm do |bm|
  bm.report('single thread') do
    MyFtp.get_file_names('my/directory').each do |file_name|
      file_data = MyFtp.download_file(file_name)
      Aws::S3.upload(file_data)
    end
  end

  bm.report('50 threads   ') do
    MultiStage.new.process
  end
end
