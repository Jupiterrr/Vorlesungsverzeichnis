class VvzWorker
  include Sidekiq::Worker

  def update(term_id)
    require "vvz_updater/vvz_updater"
    VVZUpdater.update(Vvz.find(term_id).name)
    require "search/indexer"
    KithubIndexer.new.index!
  end

end
