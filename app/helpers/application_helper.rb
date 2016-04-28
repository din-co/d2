module ApplicationHelper

  def my_taxons_tree(root_taxon, current_taxon, max_level = 1)
    return '' if max_level < 1 || root_taxon.children.empty?
    content_tag :ul, :class => 'taxons-list' do
      root_taxon.children.except(:order).order(:name).map do |taxon|
        css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'current' : nil
        content_tag :li, :class => css_class do
         link_to(taxon.name, seo_url(taxon)) +
         taxons_tree(taxon, current_taxon, max_level - 1)
        end
      end.join("\n").html_safe
    end
  end

  def restaurant_logo_url(taxon)
    image_url("restaurants/#{taxon.name.parameterize}-logo.png")
  end

  def restaurant_photo_url(taxon)
    image_url("restaurants/#{taxon.name.parameterize}-photo.png")
  end

  def chef_photo_url(taxon)
    image_url("chefs/#{taxon.name.parameterize}-photo.png")
  end

  def support_email_link(subject="Help!", link_text=nil, html_class="")
    mail_to support_email_address, link_text, subject: subject, target: "_blank", class: "text-nowrap #{html_class}"
  end

  def support_phone_link
    link_to support_phone_number, support_phone_tel, target: "_blank", class: "text-nowrap"
  end

  def support_email_address
    Rails.configuration.x.support_email_address
  end

  def support_phone_number
    Rails.configuration.x.support_phone_number
  end

  def support_phone_tel
    "tel:+1#{support_phone_number.remove('-')}"
  end

  def format_phone_number(phone_number)
    number_to_phone(phone_number.gsub(/\D/, '').sub(/^1/, ''), delimiter: "-")
  end

  def aria_label(label, suffix="-aria-label")
    "#{label}#{suffix}"
  end

  # Renders the A/B test's javascript when between options[:start] and options[:end]. If
  # either is omitted it defaults to Time.zone.now yielding an active test in production.
  # Tests are always active in pre-production environments. The helper exposes local vars
  # testName, variants, and variant in the content block, which is yielded inside a
  # <script> element.
  def ab_test_script(name, variants, options = {}, &block)
    now = Time.zone.now
    start_time = Time.zone.parse(options[:start]) rescue now
    end_time = Time.zone.parse(options[:end]) rescue now

    return nil if TRUE_PRODUCTION_INSTANCE && !now.between?(start_time, end_time)

    content = capture(&block) if block_given?
    javascript_tag do
      concat "_kmq.push(function(){\n"
      concat "  var testName = '#{j name}';\n".html_safe
      concat "  var variants = [#{Array(variants).map { |v| "'#{j v}'" }.join(',')}];\n".html_safe
      concat "  var variant = KM.ab(testName, variants);"
      unless TRUE_PRODUCTION_INSTANCE
        concat "\n  console.log('A/B test', [testName], 'selected variant:', [variant], 'from', variants, 'active: #{j start_time.to_s(:short)} - #{j end_time.to_s(:short)} #{j end_time.strftime "%Z (%z)" }');".html_safe
      end
      concat content.html_safe if content.present?
      concat "});\n"
    end.html_safe
  end
end
