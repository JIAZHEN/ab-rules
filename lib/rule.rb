module AbRules
  class Rule
    def initialize(subject, content = nil, &block)
      @subject = subject
      @content = content || subject
      @block = block
    end

    def match?
      @block ? @block.call : true
    end

    def apply
      @content
    end
  end
end
