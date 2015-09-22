module AbRules

  def self.split_by_id(id, *alternatives)
    if block_given?
      yield(alternatives[id % alternatives.size])
    else
      alternatives[id % alternatives.size]
    end
  end

  def self.split_by_rule(subject, *rules)
    if block_given?
      yield(rules.find { |r| r.match? }.apply)
    else
      rules.find { |r| r.match? }.apply
    end
  end
end

