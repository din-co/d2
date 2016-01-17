static_pages_dir = Rails.root.join("app/views/static_pages/*.html.erb")
static_page_templates = Dir[static_pages_dir.to_s].map { |f| File.basename(f, ".html.erb") }

Rails.application.config.x.static_pages = static_page_templates
