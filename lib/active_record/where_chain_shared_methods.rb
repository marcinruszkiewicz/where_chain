module ActiveRecord
  module WhereChainSharedMethods
    extend ActiveSupport::Concern

    included do
      def initialize(scope, invert=false)
        @scope = scope
        @invert = invert
      end
            
      # Returns a new relation expressing WHERE + LIKE condition
      # according to the conditions provided as a hash in the arguments.
      #
      #    Book.where.like(title: "Rails%")
      #    # SELECT * FROM books WHERE title LIKE 'Rails%'
      def like(opts, *rest)
        prepare_where(Arel::Nodes::Matches, nil, opts, rest)
      end

      # Returns a new relation expressing WHERE + NOT LIKE condition
      # according to the conditions provided as a hash in the arguments.
      #
      #    Conference.where.not_like(name: "%Kaigi")
      #    # SELECT * FROM conferences WHERE name NOT LIKE '%Kaigi'
      def unlike(opts, *rest)
        prepare_where(Arel::Nodes::DoesNotMatch, nil, opts, rest)
      end
      alias not_like unlike # maintain compatibility with activerecord-like gem

      def gt(opts, *rest)
        ensure_proper_attributes(opts)
        prepare_where(Arel::Nodes::InfixOperation, '>', opts, rest)
      end

      def gte(opts, *rest)
        ensure_proper_attributes(opts)
        prepare_where(Arel::Nodes::InfixOperation, '>=', opts, rest)
      end

      def lt(opts, *rest)
        ensure_proper_attributes(opts)
        prepare_where(Arel::Nodes::InfixOperation, '<', opts, rest)
      end

      def lte(opts, *rest)
        ensure_proper_attributes(opts)
        prepare_where(Arel::Nodes::InfixOperation, '<=', opts, rest)
      end

      private 

      def ensure_proper_attributes(opts)
        raise ArgumentError, 'This method requires a Hash as an argument.' unless opts.is_a?(Hash)

        opts.each_pair do |key, value|
          if value.is_a?(Hash) || value.is_a?(Array)
            raise ArgumentError, 'The value passed to this method should be a valid type.' 
          end
        end
      end

      def arel_node(node_type, infix, rel)
        if infix.present?
          node_type.new(infix, rel.left, rel.right)
        else
          node_type.new(rel.left, rel.right)
        end
      end      
    end
  end
end