module Hashable
    extend ActiveSupport::Concern

    included do
        before_create :generate_client_id
    end

    # all the above is required for a callback to occur inside a module

    def generate_client_id
        self.client_id = SecureRandom.hex(5)
    end

end