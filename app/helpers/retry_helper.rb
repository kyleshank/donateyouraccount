module RetryHelper
  def try_to(&block)
    retries = 0
    e = nil
    while retries < 5
      begin
        response = yield
        return response
      rescue Exception => ex
        retries += 1
        e = ex
        sleep(1)
      end
    end
    raise RetryException.new("Retry failure: #{e.class} <#{e.message}>")
  end
end

class RetryException < Exception
end