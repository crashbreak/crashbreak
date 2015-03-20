class RequestDumper < Crashbreak::BasicFormatter
  def dump
    sanitized_request_hash
  end

  private

  def sanitized_request_hash
    request_hash.map{|key, value| [key, value.to_s]}.to_h
  end

  def request_hash
    request.env
  end
end