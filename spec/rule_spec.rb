RSpec.describe AbRules::Rule do
  let(:rule) { described_class.new("foo") }

  context "when content is not given" do
    it "uses subject as content" do
      expect(rule.apply).to eq("foo")
    end
  end

  context "when block is not given" do
    it "always matches" do
      expect(rule).to be_match
    end
  end

  context "when block is given" do
    let(:subject) { double("subject", :id => id) }
    let(:rule) do
      described_class.new(subject, "control") { subject.id.even? }
    end

    context "when subject matches the rule" do
      let(:id) { 180 }

      it "matches" do
        expect(rule).to be_match
      end

      it "returns the content" do
        expect(rule.apply).to eq("control")
      end
    end

    context "when subject does not match the rule" do
      let(:id) { 133 }

      it "does not match" do
        expect(rule).not_to be_match
      end
    end
  end
end
