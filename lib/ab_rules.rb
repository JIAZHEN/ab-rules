module AbRules
  class Rule
    def initialize(content, &block)
      @content = content
      @block = block
    end

    def match?(subjects = {})
      @block ? @block.call(subjects) : true
    rescue NoMethodError
      false
    end

    def apply
      @content
    end
  end

  def self.rule(content, &block)
    Rule.new(content, &block)
  end

  def self.split_by_id(id, *alternatives)
    content = alternatives.flatten[id % alternatives.size]
    block_given? ? yield(content) : content
  end

  def self.split_by_rule(subjects = {}, *rules)
    content = rules.flatten.find { |r| r.match?(subjects) }.apply
    block_given? ? yield(content) : content
  end
end
