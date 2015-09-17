class AbRules
  def split_test(*alternatives)
    if block_given?
      yield(alternatives[recipient.id % alternatives.size])
    else
      alternatives[recipient.id % alternatives.size]
    end
  end
end
