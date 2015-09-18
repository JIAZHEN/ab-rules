RSpec.describe AbRules do
  describe ".split" do
    context "when block is not given" do
      let(:content) { described_class.split(id, "control", "test") }

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
        described_class.split(id, "control", "test", "mid") do |alter|
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
end
