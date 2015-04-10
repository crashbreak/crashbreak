class RequestDumper < Crashbreak::BasicFormatter
  def dump
    sanitized_request_hash
  end

  private

  def sanitized_request_hash
    {}.tap do |sanitized_request_hash|
      request_hash.each{|key, value| sanitized_request_hash[key] = value.to_s }
    end
  end

  def request_hash
    request.env
  end
end