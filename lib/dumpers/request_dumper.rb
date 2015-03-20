class RequestDumper < Crashbreak::BasicFormatter
  def dump
    request.env
  end
end