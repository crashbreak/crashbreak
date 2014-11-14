class TestErrorFormatter < Crashbreak::GroupFormatter
  group_name :test

  def group_hash
    { formatter: true }
  end
end
