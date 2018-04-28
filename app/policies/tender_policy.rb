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

	def save_rates?
		tender_purchased?
	end

	def save_contractors_documents?
		tender_purchased?
	end

	def results?
		tender_purchased?
	end

	def required_documents?
		user.id  == record.request_for_tender.quantity_surveyor.id
	end

	def boq?
		user.id  == record.request_for_tender.quantity_surveyor.id
	end

	def other_documents?
		user.id  == record.request_for_tender.quantity_surveyor.id
	end

	def pdf_viewer?
		user.id  == record.tender.request_for_tender.quantity_surveyor.id
	end

	def image_viewer?
		user.id  == record.tender.request_for_tender.quantity_surveyor.id
	end

	def update?
		user.id  == record.tender.request_for_tender.quantity_surveyor.id
	end

	def disqualify?
		user.id  == record.request_for_tender.quantity_surveyor.id
	end

	def undo_disqualify?
		user.id  == record.request_for_tender.quantity_surveyor.id
	end

	def rate?
		user.id  == record.request_for_tender.quantity_surveyor.id
	end


	private

	def tender_purchased?
		return true if  user.id == record.contractor.id  && record.purchased == true
	end
end