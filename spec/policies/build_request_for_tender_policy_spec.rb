# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BuildRequestForTenderPolicy do
  subject { described_class.new(publisher, request_for_tender) }

  let(:resolved_scope) do
    described_class::Scope.new(publisher, RequestForTender.all).resolve
  end

  context 'publisher does not own the request_for_tender ' \
          'and the request for tender is not published' do
    let(:publisher) { FactoryBot.create(:publisher) }
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        :not_published)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end

  context 'publisher does not own the request_for_tender ' \
          'and the request for tender is published' do
    let(:publisher) { FactoryBot.create(:publisher) }
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        :published)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end

  context 'publisher owns the request_for_tender ' \
          'and the request for tender is not published' do
    let(:publisher) { FactoryBot.create(:publisher) }
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        :not_published,
                        publisher: publisher)
    end

    it { is_expected.to permit_action(:show) }
    it { is_expected.to permit_action(:update) }
    it { is_expected.to permit_action(:create) }
  end

  context 'publisher owns the request_for_tender ' \
          'and the request for tender is published' do
    let(:publisher) { FactoryBot.create(:publisher) }
    let(:request_for_tender) do
      FactoryBot.create(:request_for_tender,
                        :published,
                        publisher: publisher)
    end

    it { is_expected.to forbid_action(:show) }
    it { is_expected.to forbid_action(:update) }
    it { is_expected.to forbid_action(:create) }
  end
end
