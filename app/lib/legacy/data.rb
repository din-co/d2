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
        spree_user = Spree::User.create({
          email: user.email,
          login: user.email,
          last_sign_in_ip: user.creation_ip,
          created_at: user.created,
          updated_at: user.last_updated,
          password: SecureRandom.hex(12), # imported users must reset their password
        })

        if spree_user.persisted?
          users_imported += 1
        else
          puts "-- user errors: #{spree_user.errors.messages}"
          next # skip to next user
        end

        state = states[user.state.try(:value)]
        spree_user_address = spree_user.addresses.build({
          firstname: user.first_name,
          lastname: user.last_name,
          address1: user.address.try(:value),
          address2: user.apt_suite.try(:value),
          city: user.city.try(:value),
          state: state,
          country: usa,
          zipcode: user.zip.try(:value),
          phone: user.phone.try(:value),
        })
        if spree_user_address.save
          addresses_imported += 1
        else
          puts "  -> address errors: #{spree_user_address.errors.messages}", true if spree_user_address.errors.present?
        end

        if user.stripe_id.present?
          spree_credit_card = spree_user.credit_cards.build({
            gateway_customer_profile_id: user.stripe_id,
            cc_type: user.card_type.try(:value),
            last_digits: user.last4.try(:value),
            name: "#{spree_user_address.firstname} #{spree_user_address.lastname}",
            default: true,
            payment_method: stripe_payment_method,
            address: spree_user_address,
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
