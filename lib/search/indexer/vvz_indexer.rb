class KithubIndexer
  class VvzIndexer
    include IndexHelper

    def index!(client)
      Vvz.find_in_batches(batch_size: 500, conditions: "name != 'KIT'") do |nodes|
        client.bulk(body: vvz_ops(nodes))
      end
    end

    def vvz_ops(nodes)
      ops = nodes.map do |node|
        data = vvz_data(node)
        index_hash(:vvz_node, node.id, data)
      end
    end

    def vvz_data(node)
      {name: node.name, term: node.term.name}
    end

  end
end
