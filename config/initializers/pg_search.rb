if Rails.env.production?
  PgSearch.multisearch_options = {
    :using => {
      :tsearch => {
        :dictionary => "german_stem"
      },
      :trigram => {},
      :dmetaphone => {
        :dictionary => "german_stem"
      }
    },
    :ignoring => :accents
  }
end