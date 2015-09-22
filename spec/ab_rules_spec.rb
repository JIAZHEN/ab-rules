RSpec.describe AbRules do
  describe ".split_by_id" do
    context "when block is not given" do
      let(:content) { described_class.split_by_id(id, "control", "test") }

      context "and id is even" do
        let(:id) { 42358 }

        it "returns the correct alternative" do
          expect(content).to eq("control")
        end
      end

      context "and id is odd" do
        let(:id) { 42359 }

        it "returns the correct alternative" do
          expect(content).to eq("test")
        end
      end
    end

    context "when block is given" do
      let(:content) do
        described_class.split_by_id(id, "control", "test", "mid") do |alter|
          "The version is #{alter}"
        end
      end

      context "and id is for the first" do
        let(:id) { 999 }

        it "returns the correct alternative" do
          expect(content).to eq("The version is control")
        end
      end

      context "and id is for the third" do
        let(:id) { 5 }

        it "returns the correct alternative" do
          expect(content).to eq("The version is mid")
        end
      end
    end
  end

  describe ".split_by_rule" do
    let(:subject) { double("subject", :id => id) }
    let(:rule_one) { described_class::Rule.new(subject, "control") { subject.id.even? } }
    let(:rule_two) { described_class::Rule.new(subject, "test") { subject.id.odd? } }

    context "when block is not given" do
      let(:content) { described_class.split_by_rule(subject, rule_one, rule_two) }

      context "and id is even" do
        let(:id) { 42358 }

        it "returns the correct alternative" do
          expect(content).to eq("control")
        end
      end

      context "and id is odd" do
        let(:id) { 42359 }

        it "returns the correct alternative" do
          expect(content).to eq("test")
        end
      end
    end

    context "when block is given" do
      let(:rule_three) { described_class::Rule.new(subject, "mid") { subject.id.odd? && subject.id % 3 == 0 } }

      let(:content) do
        described_class.split_by_rule(subject, rule_three, rule_one, rule_two) do |alter|
          "The version is #{alter}"
        end
      end

      context "and id is for the first" do
        let(:id) { 888 }

        it "returns the correct alternative" do
          expect(content).to eq("The version is control")
        end
      end

      context "and id is for the third" do
        let(:id) { 15 }

        it "returns the correct alternative" do
          expect(content).to eq("The version is mid")
        end
      end
    end
  end
end
