require 'rails_helper'

RSpec.describe Spree::Order, type: :model do
  it_behaves_like "spree order concerns"
end
