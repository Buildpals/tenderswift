# frozen_string_literal: true

class AddUniquenessIndexToRequiredDocumentUploads < ActiveRecord::Migration[5.1]
  def change
    add_index :required_document_uploads,
              %i[required_document_id tender_id],
              unique: true,
              name: 'index_rdu_on_required_document_id_and_tender_id'
  end
end
