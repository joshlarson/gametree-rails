class BraintreeService
  def initialize
    Braintree::Configuration.environment = :sandbox
    Braintree::Configuration.merchant_id = ENV["BT_MERCHANT_ID"]
    Braintree::Configuration.public_key = ENV["BT_PUBLIC_KEY"]
    Braintree::Configuration.private_key = ENV["BT_PRIVATE_KEY"]
  end

  def create_customer(id, email)
    Braintree::Customer.create(
      :email => email,
      :id => id,
    )
  end
end
