class BraintreeService
  def initialize
    Braintree::Configuration.environment = :sandbox
    Braintree::Configuration.merchant_id = ENV["BT_MERCHANT_ID"]
    Braintree::Configuration.public_key = ENV["BT_PUBLIC_KEY"]
    Braintree::Configuration.private_key = ENV["BT_PRIVATE_KEY"]
  end

  def create_customer(handle, email)
    options = {
      :email => email,
      :id => handle,
      :payment_method_nonce => "fake-valid-nonce",
    }
    log_epically "Creating Braintree Customer: #{options}"

    response = Braintree::Customer.create(options)

    log_epically("Created with Payment method token #{response.inspect}")
    conclude_log
  end

  def charge_customer(handle, amount)
    log_epically("Finding Braintree Customer #{handle}")
    response = Braintree::Customer.find(handle)

    options = {
      :amount => amount,
      :payment_method_token => response.payment_methods.first.token,
    }
    log_epically("Creating Braintree Transaction: #{options}")

    response = Braintree::Transaction.sale(options)

    log_epically(response.inspect)
    conclude_log
  end

  def log_epically(str)
    Rails.logger.info("-"*80)
    Rails.logger.info(" #{str}")
  end

  def conclude_log
    Rails.logger.info("-"*80)
  end
end
