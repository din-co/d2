module Spree
  module HomeControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :sort_by_taxon, only: :index
    end

    module InstanceMethods
      private

      def sort_by_taxon
        params[:taxon] = Spree::Taxon.homepage.id
      end
    end

  end
end
