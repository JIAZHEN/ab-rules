RSpec.describe AbRules::Rule do
  let(:rule) { described_class.new("foo") }

  context "when block is not given" do
    it "always matches" do
      expect(rule).to be_match
    end
  end

  context "when block is given" do
    let(:member) { double("member", :id => id) }
    let(:rule) do
      described_class.new("control") { |subjects| subjects[:member].id.even? }
    end

    context "when subject matches the rule" do
      let(:id) { 180 }

      it "matches" do
        expect(rule.match?(:member => member)).to eq(true)
      end

      it "returns the content" do
        expect(rule.apply).to eq("control")
      end
    end

    context "when subject does not match the rule" do
      let(:id) { 133 }

      it "does not match" do
        expect(rule.match?(:member => member)).to eq(false)
      end
    end
  end
end
