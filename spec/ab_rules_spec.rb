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
    let(:rule_one) { described_class::Rule.new("control") { subject.id.even? } }
    let(:rule_two) { described_class::Rule.new("test") { subject.id.odd? } }

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
      let(:rule_three) { described_class::Rule.new("mid") { subject.id.odd? && subject.id % 3 == 0 } }

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

  describe "gateawy selector" do
    let(:rules) do
      [
        described_class::Rule.new(:wirecard) do |subjects|
          subjects[:country] == "uk" && SITES.include?(subjects[:site].id)
        end,

        described_class::Rule.new(:worldpay) do |subjects|
          subjects[:member].id.even? && NETWORKS.include?(subjects[:network].id)
        end,

        described_class::Rule.new(:default)
      ]
    end

    before do
      SITES = [123, 567, 999]
      NETWORKS = [1, 4, 6]
    end

    context "when country is uk and site is included" do
      let(:site) { double("site", :id => 123) }
      let(:subjects) { { country: "uk", site: site } }
      let(:result) do
        described_class.split_by_rule(subjects, rules) do |content|
          "The gateway is #{content}"
        end
      end

      it "returns :wirecard" do
        expect(result).to eq("The gateway is wirecard")
      end
    end

    context "when member id is even and network is included" do
      let(:network) { double("network", :id => 1) }
      let(:member) { double("member", :id => 120) }
      let(:subjects) { { member: member, network: network } }
      let(:result) do
        described_class.split_by_rule(subjects, rules) do |content|
          "The gateway is #{content}"
        end
      end

      it "returns :worldpay" do
        expect(result).to eq("The gateway is worldpay")
      end
    end
  end
end
