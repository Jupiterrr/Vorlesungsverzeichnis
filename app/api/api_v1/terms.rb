class API_v1::Terms < Grape::API

  resource :terms do


    desc "List available terms"
    get do
      Vvz.terms.map {|term| TermPresenter.new(term).as_json }
    end


    desc "List nodes for a term."
    params do
      requires :id, type: Integer, desc: "Term id."
      optional :event_type, type: String, desc: "[short|detail]"
    end
    get ':id' do
      term = Vvz.find(params[:id])
      nodes = term.descendants
      result = nodes.map {|vvz| VvzPresenter.new(vvz).as_json }

      term.leafs.includes(:events).each do |vvz|
        vvz.events.each do |event|
          result << VvzEventPresenter.new(event, vvz).as_json(event_type: params[:event_type])
        end
      end
      result
    end


    desc "List events for a term"
    params do
      requires :id, type: Integer, desc: "Term id."
      optional :type, type: String, desc: "[default|detail]"
      optional :no, :type => Integer, :desc => "Lehrveranstaltungsnummer"
    end
    get ':id/events' do
      term = Vvz.find(params[:id])
      events = Event.where(term: term.name)
      events = events.where(no: params[:no].to_s) if params[:no]
      presenter = params[:type] == "detail" ? EventPresenter : TermEventPresenter
      events.map {|event| presenter.new(event).as_json(no_dates: false) }
    end


  end
end
