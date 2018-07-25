require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  let!(:quantity_surveyor) { FactoryBot.create(:quantity_surveyor) }
  let!(:request_for_tender) do
    FactoryBot.create(:request_for_tender,
                      quantity_surveyor: quantity_surveyor,
                      published_at: nil)
    end

  scenario 'notify admin of submitted request for tender' do
    email = AdminMailer.submit_request_for_tender(request_for_tender)
    expect(email.from).to eq(['projects@buildpals.com'])
    expect(email.to).to eq(['alfred@buildpals.com'])
    expect(email.subject).to eq("#{request_for_tender
                                .quantity_surveyor
                                .company_name}"\
                                'submitted a new request for tender')
    expect { email.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  scenario 'notify quantity surveyor of published request for tender' do
    email = AdminMailer.publish_request_for_tender(request_for_tender)
    expect(email.from).to eq(['projects@buildpals.com'])
    expect(email.to).to eq([request_for_tender.quantity_surveyor.email])
    expect(email.subject).to eq("#{request_for_tender.project_name} has been published")
    expect { email.deliver_now }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end
end