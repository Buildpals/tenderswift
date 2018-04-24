class TenderPolicy < ApplicationPolicy
	class Scope < Scope
		def resolve
			scope.all
		end
	end

	def project_information?
		if record.request_for_tender.private == true
			tender_purchased?
		else
			true
		end
	end

	def tender_documents?
		tender_purchased?
	end

	def boq?
		tender_purchased?
	end

	def contractors_documents?
		tender_purchased?
	end

	def save_rates
		tender_purchased?
	end

	def save_contractors_documents
		tender_purchased?
	end

	private

	def tender_purchased?
		return true if  user.id == record.contractor.id  && record.purchased == true
	end
end