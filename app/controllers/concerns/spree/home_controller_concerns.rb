module Spree
  module HomeControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :sort_by_taxon, only: :index
    end

    module InstanceMethods
      def sort_by_taxon
        params[:taxon] = Spree::Taxon.pages.find_by(name: "Home").try(:id)
      end
    end

  end
end
