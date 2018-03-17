module ActiveRecord
  class Relation
    class QueryMethods; end
  end

  module QueryMethods
    class WhereChain
      def initialize(scope, invert=false)
        @scope = scope
        @invert = invert
      end

      def not(opts = :chain, *rest)
        if opts == :chain
          @invert = true
          return self
        end

        opts = sanitize_forbidden_attributes(opts)

        where_clause = @scope.send(:where_clause_factory).build(opts, rest)

        @scope.references!(PredicateBuilder.references(opts)) if Hash === opts
        @scope.where_clause += where_clause.invert
        @scope
      end

      # Returns a new relation expressing WHERE + LIKE condition
      # according to the conditions provided as a hash in the arguments.
      #
      #    Book.where.like(title: "Rails%")
      #    # SELECT * FROM books WHERE title LIKE 'Rails%'
      def like(opts, *rest)
        prepare_where(Arel::Nodes::Matches, nil, opts, rest)
      end

      # test if Conference.where.not.like(name: "%Kaigi") works

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
        prepare_where(Arel::Nodes::InfixOperation, '>', opts, rest)
      end

      def gte(opts, *rest)
        prepare_where(Arel::Nodes::InfixOperation, '>=', opts, rest)
      end

      def lt(opts, *rest)
        prepare_where(Arel::Nodes::InfixOperation, '<', opts, rest)
      end

      def lte(opts, *rest)
        prepare_where(Arel::Nodes::InfixOperation, '<=', opts, rest)
      end

      private 

      def prepare_where(node_type, infix, opts, rest)
        opts = opts.reject { |_, v| v.is_a?(Array) && v.empty? }

        @scope.tap do |s|
          opts.each_pair do |key, value|
            equal_where_clause = s.send(:where_clause_factory).build({ key => value }, rest)
            equal_where_clause_predicate = equal_where_clause.send(:predicates).first

            new_predicate = build_arel_node(node_type, infix, equal_where_clause_predicate)
            new_where_clause = Relation::WhereClause.new([new_predicate], equal_where_clause.binds)
            if @invert
              s.where_clause += new_where_clause.invert
            else
              s.where_clause += new_where_clause
            end
          end
        end
      end
      
      def build_arel_node(node_type, infix, rel)
        if infix.present?
          node_type.new(infix, rel.left, rel.right)
        else
          node_type.new(rel.left, rel.right)
        end
      end
    end
  end
end