# frozen_string_literal: true

module ActiveRecord
  module WhereChainSharedMethods
    extend ActiveSupport::Concern

    included do
      # Initialize the chain with a scope and a toggle to invert the generated
      # where statement
      def initialize(scope, invert=false)
        @scope = scope
        @invert = invert
      end

      # Returns a new relation expressing WHERE + LIKE condition
      # according to the conditions provided as a hash in the arguments.
      #
      #    Book.where.like(title: "Rails%")
      #    # SELECT * FROM books WHERE books.title LIKE 'Rails%'
      def like(opts, *rest)
        prepare_where(Arel::Nodes::Matches, nil, opts, rest)
      end

      # Returns a new relation expressing WHERE + NOT LIKE condition
      # according to the conditions provided as a hash in the arguments.
      #
      #    Conference.where.not_like(name: "%Kaigi")
      #    # SELECT * FROM conferences WHERE conferences.name NOT LIKE '%Kaigi'
      #
      # Also aliased as .not_like to maintain compatibility with the
      # activerecord-like gem
      def unlike(opts, *rest)
        prepare_where(Arel::Nodes::DoesNotMatch, nil, opts, rest)
      end
      alias_method :not_like, :unlike

      # Returns a new relation expressing a greater than condition in WHERE
      # according to the conditions in an argument hash
      #
      #    Conference.where.gt(speakers: 10)
      #    # SELECT * FROM conferences WHERE conferences.speakers > 10
      def gt(opts, *rest)
        ensure_proper_attributes(opts)
        prepare_where(Arel::Nodes::InfixOperation, '>', opts, rest)
      end

      # Returns a new relation expressing a greater than or equal condition in WHERE
      # according to the conditions in an argument hash
      #
      #    Conference.where.gte(speakers: 10)
      #    # SELECT * FROM conferences WHERE conferences.speakers >= 10
      def gte(opts, *rest)
        ensure_proper_attributes(opts)
        prepare_where(Arel::Nodes::InfixOperation, '>=', opts, rest)
      end

      # Returns a new relation expressing a less than condition in WHERE
      # according to the conditions in an argument hash
      #
      #    Conference.where.lt(date: DateTime.new(2018, 3, 18))
      #    # SELECT * FROM conferences WHERE conferences.date < '2018-03-18 00:00:00'
      def lt(opts, *rest)
        ensure_proper_attributes(opts)
        prepare_where(Arel::Nodes::InfixOperation, '<', opts, rest)
      end

      # Returns a new relation expressing a less than or equal condition in WHERE
      # according to the conditions in an argument hash
      #
      #    Conference.where.lt(date: DateTime.new(2018, 3, 18))
      #    # SELECT * FROM conferences WHERE conferences.date <= '2018-03-18 00:00:00'
      def lte(opts, *rest)
        ensure_proper_attributes(opts)
        prepare_where(Arel::Nodes::InfixOperation, '<=', opts, rest)
      end

      private

      # Ensures that the arguments passed to methods are a Hash and that the value in the argument
      # hash is not another Hash or Array.
      def ensure_proper_attributes(opts)
        raise ArgumentError, 'This method requires a Hash as an argument.' unless opts.is_a?(Hash)

        opts.each_pair do |_key, value|
          if value.is_a?(Hash) || value.is_a?(Array)
            raise ArgumentError, 'The value passed to this method should be a valid type.'
          end
        end
      end

      # Arel::Nodes::InfixOperation.new expects more arguments than other Arel nodes
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
