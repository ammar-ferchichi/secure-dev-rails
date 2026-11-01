# INTENTIONALLY VULNERABLE — see app/controllers/secure/documents_controller.rb for the fix.
module Vulnerable
  class DocumentsController < BaseController
    # A03 Injection — user input is concatenated into SQL.
    # Payload: q = %') OR 1=1 --   closes the condition and returns every user's documents.
    def index
      @documents = Document.where("user_id = #{Current.user.id} AND title LIKE '%#{params[:q]}%'")
      render "secure/documents/index"
    end

    # A01 Broken Access Control (IDOR) — any logged-in user can read any document by id.
    def show
      @document = Document.find(params[:id])
    end
  end
end
