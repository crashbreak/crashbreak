class TestErrorFormatter < Crashbreak::GroupFormatter
  group_name :test

  def group_hash(exception)
    { formatter: true }
  end
end
