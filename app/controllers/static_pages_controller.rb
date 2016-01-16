class StaticPagesController < Spree::StoreController
  def show
    if valid_page?
      render template: template_path
    else
      render file: 'public/404.html'
    end
  end

private
  def valid_page?
    Rails.application.config.x.static_pages.include?(params[:page]) &&
    File.exist?(template_file)
  end

  def template_path
    "static_pages/#{params[:page]}.html.erb"
  end

  def template_file
    Rails.root.join("app/views", template_path)
  end
end
