# encoding: utf-8
class Vvz < ActiveRecord::Base
  has_and_belongs_to_many :events, uniq: true
  has_ancestry cache_depth: true

  include PgSearch
  multisearchable :against => [:name]
  pg_search_scope :vvz_search,
                  :against => :name,
                  :using => {
                    :tsearch => {:prefix => true},
                    :trigram => {:prefix => true}
                  }

  JSON_PREFIX = "#"

  alias_attribute :leaf?, :is_leaf
  alias_attribute :is_leaf?, :is_leaf

  def to_preload
      children = children!.map { |n| n.preload_id }
      [preload_id, name, children]
  end

  def children!
    is_leaf? ? events : children
  end

  def self.leafs
    where(is_leaf: true)
  end

  def leafs
    descendants.where(is_leaf: true)
  end

  def self.root
    roots.first
  end

  def preload_id
    JSON_PREFIX + id.to_s
  end

  def is_term?
    depth == 1
  end
  alias_method :term?, :is_term?

  def vvz_node?
    depth > 1
  end

  def self.current_term
    terms = self.roots.first.children
    @@current_term ||= terms.find_by_name("WS 2014") || terms.first
  end

  def self.find_or_current_term(id)
    id.nil? ? self.current_term : self.find(id)
  end

  def self.university(name)
    Vvz.roots.find_by_name(name)
  end

  def self.university!(name)
    Vvz.roots.find_by_name!(name)
  end

  def self.find_or_create_university(name)
    university(name) or Vvz.roots.create name: name
  end

  def self.term(university, term_name)
    root = self.university(university)
    root.children.find_by_name(term_name)
  end

  def term
    path[1]
  end

  def vvz_path
    if vvz_node?
      # drops university and term id
      path_ids[2..-1]
    else
      []
    end
  end

  private

  def self.terms
    root = university("KIT")
    root.children
  end

  NAMES = [
    {
      :key => "House of Competence (HoC)  -  Lehrveranstaltungen für alle Studierenden",
      :value => "House of Competence"
    },
    {
      :key => "International Department der Universität Karlsruhe (TH) Carl Benz School of Engineering",
      :value => "International Department"
    },
    {
      :key => "Lehrveranstaltungen des Sprachenzentrums",
      :value => "Sprachenzentrum"
    },
    {
      :key => "Lehrveranstaltungen im Rahmen des EUCOR Verbundes",
      :value => "EUCOR Verbunde"
    },
    {
      :key => "Studienkolleg für ausländische Studierende",
      :value => "Studienkolleg"
    },
    {
      :key => "Studium Generale und Zusatzqualifikationen für Studierende aller Fakultäten",
      :value => "Studium Generale und Zusatzqualifikationen"
    },
    {
      :key => "Veranstaltungen des Zentrums für Information und Beratung (zib)",
      :value => "Zentrums für Information und Beratung"
    },
    {
      :key => "Veranstaltungen für Benutzer des Steinbuch Centre for Computing (SCC)",
      :value => "Steinbuch Centre for Computing"
    }
  ]

end

