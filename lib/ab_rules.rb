module AbRules
  def self.split(id, *alternatives)
    if block_given?
      yield(alternatives[id % alternatives.size])
    else
      alternatives[id % alternatives.size]
    end
  end

  def self.split(id, rules)
    yield(rules.find{|r| r.match?}.content)
  end
end

