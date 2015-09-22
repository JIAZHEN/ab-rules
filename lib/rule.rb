module AbRules
  class Rule
    def initialize(content, &block)
      @content = content
      @block = block
    end

    def match?(subjects = {})
      @block ? @block.call(subjects) : true
    end

    def apply
      @content
    end
  end
end
