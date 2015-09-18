module AbRules
  class Rule
    def initialize(subject:, content: nil)
      @subject = subject
      @content = content || subject
    end
  end
end
