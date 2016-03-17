class StaticPagesController < Spree::StoreController
  def show
    if defined_static_page?
      render template: template_path
    elsif active_promotion?
      if promo = Spree::Promotion.active.find_by(path: params[:page])
        session[:page_promotion] = params[:page]
        flash[:notice] = "Congratulations! You qualify for #{promo.description}, #{promo.name}"
      end
      redirect_to root_path
    else
      render file: 'public/404.html'
    end
  end

  private
  def valid_page?
    defined_static_page? || active_promotion?
  end

  def defined_static_page?
    Rails.configuration.x.static_pages.include?(params[:page]) &&
    File.exist?(template_file)
  end

  def active_promotion?
    Spree::Promotion.where(path: params[:path]).exists?
  end

  def template_path
    "static_pages/#{params[:page]}.html.erb"
  end

  def template_file
    Rails.root.join("app/views", template_path)
  end
end
