# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BidPolicy do
  subject { described_class.new(publisher, tender) }

  let(:publisher) do
    FactoryBot.create(:publisher)
  end

  context 'publisher owns the request_for_tender and' \
          'the tender is reviewable' do

    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        publisher: publisher,
                        deadline: Time.current)
    end

    let(:tender) do
      FactoryBot.build(:purchased_tender,
                       request_for_tender: request_for_tender,
                       submitted_at: Time.current)
    end

    it { is_expected.to permit_action(:required_documents) }
    it { is_expected.to permit_action(:boq) }
    it { is_expected.to permit_action(:other_documents) }
    it { is_expected.to permit_action(:disqualify) }
    it { is_expected.to permit_action(:undo_disqualify) }
    it { is_expected.to permit_action(:rate) }
  end

  context 'publisher does not own the request for tender' do
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        deadline: Time.current)
    end

    let(:tender) do
      FactoryBot.build(:purchased_tender,
                       request_for_tender: request_for_tender,
                       submitted_at: Time.current - 1.days)
    end

    it { is_expected.to forbid_action(:required_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:other_documents) }
    it { is_expected.to forbid_action(:disqualify) }
    it { is_expected.to forbid_action(:undo_disqualify) }
    it { is_expected.to forbid_action(:rate) }
  end

  context 'the tender is not purchased' do
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        publisher: publisher,
                        deadline: Time.current)
    end

    let(:tender) do
      FactoryBot.build(:tender,
                       purchased_at: nil,
                       request_for_tender: request_for_tender,
                       submitted_at: Time.current - 1.days)
    end

    it { is_expected.to forbid_action(:required_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:other_documents) }
    it { is_expected.to forbid_action(:disqualify) }
    it { is_expected.to forbid_action(:undo_disqualify) }
    it { is_expected.to forbid_action(:rate) }
  end

  context 'the tender is not submitted' do
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        publisher: publisher,
                        deadline: Time.current)
    end

    let(:tender) do
      FactoryBot.build(:purchased_tender,
                       request_for_tender: request_for_tender,
                       submitted_at: nil)
    end

    it { is_expected.to forbid_action(:required_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:other_documents) }
    it { is_expected.to forbid_action(:disqualify) }
    it { is_expected.to forbid_action(:undo_disqualify) }
    it { is_expected.to forbid_action(:rate) }
  end

  context 'the tender deadline is not over' do
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        publisher: publisher,
                        deadline: Time.current + 2.days)
    end

    let(:tender) do
      FactoryBot.build(:purchased_tender,
                       request_for_tender: request_for_tender,
                       submitted_at: Time.current)
    end

    it { is_expected.to forbid_action(:required_documents) }
    it { is_expected.to forbid_action(:boq) }
    it { is_expected.to forbid_action(:other_documents) }
    it { is_expected.to forbid_action(:disqualify) }
    it { is_expected.to forbid_action(:undo_disqualify) }
    it { is_expected.to forbid_action(:rate) }
  end
end