# Protected by routes.rb
class PersonalPromosController < Spree::StoreController
  def show
    if promo = Spree::Promotion.active.find_by(path: params[:personal_promo])
      flash[:notice] = "Congratulations! You qualify for #{promo.description}, #{promo.name}."
      if promo.user_id == spree_current_user.try(:id)
        flash[:notice] = "People you share with will see: #{flash[:notice]}"
      else
        cookies.permanent.signed[:page_promotion] = promo.path
      end
    else
      render file: 'public/404.html'
    end
  end
end
