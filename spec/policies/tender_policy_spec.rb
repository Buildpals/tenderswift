require "rails_helper"

RSpec.describe TenderPolicy  do
	subject { described_class.new(contractor, tender) }

	let(:quantity_surveyor) { FactoryBot.build(:quantity_surveyor) }
	let(:request_for_tender) { FactoryBot.build(:request_for_tender) }
	let(:tender) { FactoryBot.build(:purchased_tender) }
 	let(:contractor) { FactoryBot.build(:contractor) }

	context 'contractor owns a tender' do
    		  it { is_expected.to permit_action(:project_information) }
	end
end