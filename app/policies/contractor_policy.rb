class ContractorPolicy < ApplicationPolicy
	class Scope < Scope
		def resolve
			scope.all
		end
	end
	
	def edit?
		verify_contractor
	end

	def update?
		verify_contractor
	end

	private

	def verify_contractor
		return true if  user.id == record.id 
	end
end