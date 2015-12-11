class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_taxonomies

  def set_taxonomies
    @restaurants_taxonomy = Spree::Taxonomy.where(:name => 'Restaurants').first
    @restaurants_taxonomy_id = @restaurants_taxonomy.id
    @pantry_taxonomy = Spree::Taxonomy.where(:name => 'Pantry').first
    @pantry_taxonomy_id = @pantry_taxonomy.id
    @diets_taxonomy = Spree::Taxonomy.where(:name => 'Diets').first
    @diets_taxonomy_id = @diets_taxonomy.id
    @chefs_taxonomy = Spree::Taxonomy.where(:name => 'Chefs').first
    @chefs_taxonomy_id = @chefs_taxonomy.id
  end

end
