class OtherDocumentUploadPolicy < ApplicationPolicy
	class Scope < Scope
		def resolve
			scope.all
		end
	end
	
	def other_documents?
		user.id == record.request_for_tender.quantity_suveyor.id
	end

	def pdf_viewer?
		verify_quantity_surveyor
	end

	def image_viewer?
		verify_quantity_surveyor
	end

	def update
		verify_quantity_surveyor
	end

	private

	def verify_quantity_surveyor
		return true if  user.id == record.tender.request_for_tender.quantity_suveyor.id
	end
end