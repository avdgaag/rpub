module Rpub
  # Delegate missing methods to keys in a Hash atribute on the current object.
  module HashDelegation
    def self.included(base)
      def base.delegate_to_hash(attr)
        define_method(:delegated_hash) { send attr }
      end
    end

    def respond_to?(m)
      super || delegated_hash.has_key?(m.to_s)
    end

    def method_missing(m, *args, &block)
      return super unless respond_to? m
      delegated_hash.fetch m.to_s
    end
  end
end
