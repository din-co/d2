require 'rails_helper'

RSpec.describe Spree::Address, type: :model do
  it_behaves_like "spree address concerns"
end
