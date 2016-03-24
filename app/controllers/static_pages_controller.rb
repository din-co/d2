class StaticPagesController < Spree::StoreController
  def show
    if defined_static_page?
      render template: template_path
    else
      render file: 'public/404.html'
    end
  end

  private
  def valid_page?
    defined_static_page? && File.exist?(template_file)
  end

  def defined_static_page?
    Rails.configuration.x.static_pages.include?(params[:path])
  end

  def template_path
    "static_pages/#{params[:path]}.html.erb"
  end

  def template_file
    Rails.root.join("app/views", template_path)
  end
end
