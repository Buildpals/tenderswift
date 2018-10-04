# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PurchaseTenderPolicy do
  subject { described_class.new(contractor, request_for_tender) }

  let(:contractor) do
    FactoryBot.create(:contractor)
  end

  context 'the request_for_tender is published' do
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        published_at: Time.current - 2.days)
    end

    it { is_expected.to permit_action(:portal) }
    it { is_expected.to permit_action(:purchase) }
    it { is_expected.to permit_action(:monitor_purchase) }
    it { is_expected.to permit_action(:complete_transaction) }
  end

  context 'the request_for_tender is not published' do
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        published_at: nil)
    end

    it { is_expected.to forbid_action(:portal) }
    it { is_expected.to forbid_action(:purchase) }
    it { is_expected.to forbid_action(:monitor_purchase) }
    it { is_expected.to permit_action(:complete_transaction) }
  end
end