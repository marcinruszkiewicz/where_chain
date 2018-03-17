module ActiveRecord
  module WhereChainExtensions
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

    def arel_node(node_type, infix, rel)
      if infix.present?
        node_type.new(infix, rel.left, rel.right)
      else
        node_type.new(rel.left, rel.right)
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord.eager_load!

  ActiveRecord::QueryMethods::WhereChain.send(:include, ::ActiveRecord::WhereChainExtensions)
end