# frozen_string_literal: true

module ActiveRecord
  # Ruby complains about missing the class if we try to patch it without it
  class Relation
    class QueryMethods; end
  end

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
      # Note: This is the Active Record 5 version.
      def not(opts = :chain, *rest)
        if opts == :chain
          @invert = true
          return self
        end

        opts = sanitize_forbidden_attributes(opts)

        where_clause = @scope.send(:where_clause_factory).build(opts, rest)

        @scope.references!(PredicateBuilder.references(opts)) if opts.is_a?(Hash)
        @scope.where_clause += where_clause.invert
        @scope
      end

      private

      # Prepare the WHERE clause by inserting a proper Arel node and inverting
      # it if necessary.
      #
      # Note: This is the Active Record 5 version.
      def prepare_where(node_type, infix, opts, rest)
        @scope.tap do |s|
          opts.each_pair do |key, value|
            equal_where_clause = s.send(:where_clause_factory).build({ key => value }, rest)
            equal_where_clause_predicate = equal_where_clause.send(:predicates).first

            new_predicate = arel_node(node_type, infix, equal_where_clause_predicate)
            new_where_clause = build_where_clause(new_predicate, equal_where_clause)
            s.where_clause += if @invert
                                new_where_clause.invert
                              else
                                new_where_clause
                              end
          end
        end
      end

      # Active Record 5.2 changed the API and removed binds method so we need to pass
      # proper arguments to build a WHERE clause
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
