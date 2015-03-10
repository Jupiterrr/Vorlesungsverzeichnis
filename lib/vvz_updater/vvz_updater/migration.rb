module VVZUpdater
  class Migration

    attr_reader :term, :tree, :events

    UNIVERSITY = "KIT"

    def initialize(term, options={})
      @term = term
      @tree = options.fetch(:tree, nil)
      @events = options.fetch(:events, nil)
    end

    def run
      logger.info %Q[start Migration: term="#{term}"]
      mirgrate_tree! if tree
      update_events! if events
      link_events! if tree
      improve_names!
    end

    def mirgrate_tree!
      logger.info "start TreeMigration"
      TreeMigration.new(db_term, tree).migrate!
    end

    def update_events!
      logger.info "start EventUpdater"
      EventUpdater.run!(term, events)
      logger.info "start EventDateUpdater"
      EventDateUpdater.run!(term, events)
    end

    def link_events!
      logger.info "start EventLinker"
      EventLinker.run!(term, tree.leafs)
    end

    def improve_names!
      logger.info "improving names"
      DataEnhancer.new(term).improve_names()
    end

    def db_term
      Vvz.find_or_create_term(UNIVERSITY, term)
    end

    def logger
      VVZUpdater.logger
    end

  end
end
