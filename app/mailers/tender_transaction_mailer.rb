# frozen_string_literal: true

class TenderTransactionMailer < ApplicationMailer
  helper ApplicationHelper
  helper RequestForTendersHelper

  default from: 'projects@buildpals.com'

  def confirm_purchase_email(tender)
    @tender = tender
    mail(to: @tender.contractors_email,
         subject: 'Successful purchase of tender documents')
  end
end
