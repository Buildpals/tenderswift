module HasProject
  extend ActiveSupport::Concern

  def name
    if contractor.company_name.blank?
      contractor.email
    else
      contractor.company_name
    end
  end

  def project_owners_name
    request_for_tender.project_owners_name
  end

  def project_owners_company_name
    request_for_tender.project_owners_company_name
  end

  def project_owners_company_logo
    request_for_tender.project_owners_company_logo
  end

  def project_owners_phone_number
    request_for_tender.project_owners_phone_number
  end

  def project_owners_email
    request_for_tender.project_owners_email
  end

  def project_name
    request_for_tender.project_name
  end

  def project_deadline
    request_for_tender.deadline
  end

  def project_location
    request_for_tender.project_location
  end

  def project_description
    request_for_tender.description
  end

  def project_budget
    return 0
  end

  def contract_sum_currency
    request_for_tender.contract_sum_currency
  end

  def contract_sum
    request_for_tender.contract_sum
  end

  def project_documents
    request_for_tender.project_documents
  end

  def deadline_over?
    request_for_tender.deadline_over?
  end
end