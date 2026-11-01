module Secure
  class DocumentsController < ApplicationController
    # A03 Injection — fixed: parameterized query, LIKE wildcards escaped, scoped to the current user.
    def index
      @documents = Current.user.documents
      if params[:q].present?
        @documents = @documents.where("title LIKE ?", "%#{Document.sanitize_sql_like(params[:q])}%")
      end
    end

    # A01 Broken Access Control (IDOR) — fixed: lookup is scoped to the current user,
    # so another user's id raises RecordNotFound (404) instead of leaking data.
    def show
      @document = Current.user.documents.find(params[:id])
    end
  end
end
