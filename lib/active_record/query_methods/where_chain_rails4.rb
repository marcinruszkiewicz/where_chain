module ActiveRecord
  module QueryMethods
    class WhereChain
      # overwrite WhereChain to support chaining where.not.
      def initialize(scope, invert=false)
        @scope = scope
        @invert = invert
      end

      # if passed nothing, default to chaining further
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
    end
  end
end