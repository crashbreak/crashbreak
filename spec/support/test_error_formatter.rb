class TestErrorFormatter < Crashbreak::HashFormatter
  hash_name :test

  def hash_value
    { formatter: true }
  end
end
