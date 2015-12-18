module Legacy
  class Data
    def self.load!
      puts "== Importing legacy Users =================================="

      usa = Spree::Country.find_by(iso: 'US') || Spree::Country.first
      states = { # need string hash keys, thus => syntax
        "CA" => Spree::State.find_by(abbr: 'CA', country: usa),
        "NV" => Spree::State.find_by(abbr: 'NV', country: usa),
      }
      stripe_payment_method = Spree::PaymentMethod.find_by(type: "Spree::Gateway::StripeGateway")

      users_imported = 0
      addresses_imported = 0
      stripe_ids_imported = 0
      Legacy::User.find_each do |user|
        spree_user = Spree::User.find_or_create_by(email: user.email) do |spree_user|
          spree_user.login = user.email
          spree_user.last_sign_in_ip = user.creation_ip
          spree_user.created_at = user.created
          spree_user.updated_at = user.last_updated
          spree_user.password = SecureRandom.hex(12) # imported users must set a new password
        end

        if spree_user.persisted?
          users_imported += 1
        else
          puts "-- user errors: #{spree_user.errors.messages}"
          next unless spree_user.errors[:email] = ["has already been taken"] # skip to next user unless we are re-importing
        end

        # skip to next user if we already imported an address
        next if spree_user.user_addresses.present?

        state = states[user.state]
        address = Spree::Address.new({
          firstname: user.first_name,
          lastname: user.last_name,
          address1: user.address,
          address2: user.apt_suite,
          city: user.city,
          state: state,
          country: usa,
          zipcode: user.zip,
          phone: user.phone,
        })
        spree_user.default_address = address
        address = spree_user.default_address
        if address.persisted?
          addresses_imported += 1
        else
          puts "  -> address errors: #{address.errors.messages}", true if address.errors.present?
        end

        if user.stripe_id.present?
          spree_credit_card = spree_user.credit_cards.build({
            gateway_customer_profile_id: user.stripe_id,
            cc_type: user.card_type,
            last_digits: user.last4,
            name: "#{address.firstname} #{address.lastname}",
            default: true,
            payment_method: stripe_payment_method,
            address: address,
          })
          if spree_credit_card.save
            stripe_ids_imported += 1
          else
            puts "  -> credit card errors: #{spree_credit_card.errors.messages}", true if spree_credit_card.errors.present?
          end
        end
      end

      puts "== Imported: ==============================================="
      puts ["#{users_imported} users", "#{addresses_imported} addresses", "#{stripe_ids_imported} Stripe IDs"]
    end
  end
end
