namespace :legacy do
  desc "Load legacy data into the current Rails.env"
  task load: :environment do
  	Legacy::Data.load!
  end
end
