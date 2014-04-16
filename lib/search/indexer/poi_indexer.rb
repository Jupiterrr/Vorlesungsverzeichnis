class KithubIndexer
  class PoiIndexer
    include IndexHelper

    def index!(client)
      Poi.find_in_batches(batch_size: 500) do |pois|
        client.bulk(body: poi_ops(pois))
      end
    end

    def poi_ops(pois)
      ops = pois.map do |poi|
        data = poi_data(poi)
        index_hash(:poi, poi.id, data)
      end
    end

    def poi_data(poi)
      {name: poi.name, building_no: poi.building_no, address: poi.address}
    end

  end
end
