require 'rails_helper'

module Spree
  RSpec.describe PaymentCreate, with: :seeds do
    let(:user) { nil }
    let(:order) { FactoryGirl.create :order, user: user }
    let(:request_env) { {} }
    let(:payment_create) { described_class.new(order, attributes, request_env: request_env) }
    let(:payment_method) { Spree.default_payment_method }
    let(:new_payment) { payment_create.build }

    context 'empty attributes' do
      let(:attributes){ {} }
      it "builds a new empty payment" do
        expect(new_payment).to be_a Spree::Payment
        expect(new_payment.order).to eq order
        expect(new_payment.source).to be_nil
      end

      it "builds the payment in order.payments" do
        expect(order.payments).to eq [new_payment]
      end
    end

    context 'with a new source' do
      let(:attributes) do
        {
          "amount" => 3499,
          "payment_method_id" => payment_method.id,
          "source_attributes" => {
            "month" => "12",
            "year" => "2016",
            "cc_type" => "Visa",
            "gateway_payment_profile_id" => "tok_8J6xOwvX4p8pUC",
            "last_digits" => "4242",
            "name" => "John Doe",
            "default"=>true,
          }
        }
      end

      it 'uses Stripe' do
        expect(payment_method.name).to eq("Stripe")
        expect(payment_method).to be_valid
        expect(payment_method).to be_persisted
        expect(Spree::PaymentMethod.find(payment_method.id)).to eq payment_method
      end

      it "should build the payment's source" do
        expect(new_payment).to be_valid

        expect(new_payment.source).not_to be_nil
        expect(new_payment.source.user_id).to eq order.user_id
        expect(new_payment.source.payment_method_id).to eq payment_method.id
      end
    end
  end
end
