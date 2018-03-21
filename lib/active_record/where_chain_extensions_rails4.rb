module ActiveRecord
  module QueryMethods
    class WhereChain
      include WhereChainSharedMethods

      # Returns a new relation expressing WHERE + NOT condition
      # according to the conditions in the arguments.
      #
      #    User.where.not(name: nil)
      #    # SELECT * FROM users WHERE users.name IS NOT NULL
      #
      # If there is no argument, chain further.
      #
      #    User.where.not.gt(login_count: 3)
      #    # SELECT * FROM users WHERE NOT(users.login_count > 3)
      #
      # Note: This is the Active Record 4 version.
      def not(opts = :chain, *rest)
        where_value = @scope.send(:build_where, opts, rest).map do |rel|
          case rel
          when :chain
            @invert = true
            return self
          when NilClass
            raise ArgumentError, 'Invalid argument for .where.not(), got nil.'
          when Arel::Nodes::In
            Arel::Nodes::NotIn.new(rel.left, rel.right)
          when Arel::Nodes::Equality
            Arel::Nodes::NotEqual.new(rel.left, rel.right)
          when String
            Arel::Nodes::Not.new(Arel::Nodes::SqlLiteral.new(rel))
          else
            Arel::Nodes::Not.new(rel)
          end
        end

        @scope.references!(PredicateBuilder.references(opts)) if Hash === opts
        @scope.where_values += where_value
        @scope
      end

      private

      # Prepare the WHERE clause by inserting a proper Arel node and inverting
      # it if necessary.
      #
      # Note: This is the Active Record 4 version.
      def prepare_where(node_type, infix, opts, *rest)
        where_value = @scope.send(:build_where, opts, rest).map do |rel|
          if @invert
            Arel::Nodes::Not.new arel_node(node_type, infix, rel)
          else
            arel_node(node_type, infix, rel)
          end
        end
        @scope.where_values += where_value
        @scope
      end
    end
  end
end
