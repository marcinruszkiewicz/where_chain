module ActiveRecord
  class Relation
    class QueryMethods; end
  end

  module QueryMethods
    class WhereChain
      include WhereChainSharedMethods

      def not(opts = :chain, *rest)
        if :chain == opts
          @invert = true
          return self
        end

        opts = sanitize_forbidden_attributes(opts)

        where_clause = @scope.send(:where_clause_factory).build(opts, rest)

        @scope.references!(PredicateBuilder.references(opts)) if Hash === opts
        @scope.where_clause += where_clause.invert
        @scope
      end

      private 

      def prepare_where(node_type, infix, opts, rest)
        @scope.tap do |s|
          opts.each_pair do |key, value|
            equal_where_clause = s.send(:where_clause_factory).build({ key => value }, rest)
            equal_where_clause_predicate = equal_where_clause.send(:predicates).first

            new_predicate = arel_node(node_type, infix, equal_where_clause_predicate)
            new_where_clause = build_where_clause(new_predicate, equal_where_clause)
            if @invert
              s.where_clause += new_where_clause.invert
            else
              s.where_clause += new_where_clause
            end
          end
        end
      end

      def build_where_clause(new_predicate, old_where_clause)
        if old_where_clause.respond_to?(:binds)
          Relation::WhereClause.new([new_predicate], old_where_clause.binds)
        else
          Relation::WhereClause.new([new_predicate])
        end
      end   
    end
  end
end