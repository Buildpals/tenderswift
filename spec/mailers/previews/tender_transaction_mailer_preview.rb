# Preview all emails at http://localhost:3000/rails/mailers/tender_transaction_mailer
class TenderTransactionMailerPreview < ActionMailer::Preview
  def confirm_purchase_email
    TenderTransactionMailer.confirm_purchase_email(Tender.first)
  end
end
