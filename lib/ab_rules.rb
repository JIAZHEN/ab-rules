module AbRules

  def self.split_by_id(id, *alternatives)
    content = alternatives.flatten[id % alternatives.size]
    block_given? ? yield(content) : content
  end

  def self.split_by_rule(subjects = {}, *rules)
    content = rules.flatten.find { |r| r.match?(subjects) }.apply
    block_given? ? yield(content) : content
  end
end
