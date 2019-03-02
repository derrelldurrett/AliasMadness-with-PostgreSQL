require 'assets/rgl/directed_adjacency_graph'
require 'assets/errors/bad_programmer_error'
require 'initialize_bracket/bracket_template'
require 'helpers/hash_helper'
require 'helpers/hash_class_helper'
require 'helpers/json_client_helper'
require 'helpers/json_client_class_helper'
class Bracket < ApplicationRecord
  @@cached_teams= []
  include HashHelper
  extend HashClassHelper
  include JSONClientHelper
  extend JSONClientClassHelper
  serialize :bracket_data, BracketTemplate
  serialize :lookup_by_label, Hash
  attr_accessor :bracket_data
  belongs_to :user, optional: true
  has_many :games, inverse_of: :bracket
  after_find :init_lookups

  self.hash_vars= %i(id user)
  self.json_client_ids= [:id, :nodes]

  def teams
    @@cached_teams.length > 0 or init_cached_teams
    @@cached_teams
  end

  def init_cached_teams
    init_lookups if lookup_by_label_uninitialized?
    lookup_by_label.each do |l, n|
      @@cached_teams << n if n.is_a?(Team)
    end
  end

  def teams_attributes=(name)
    puts "Got attributes: #{name}"
  end

  def initialization_data
    bracket_data.edges
  end

  def lookup_game(l)
    # This probably can change to not always look at the DB
    g= Game.where(bracket_id: self.id, label: l).first
  end

  def lookup_node(n)
    init_lookups if lookup_by_label_uninitialized?
    lookup_by_label[n.to_s]
  end

  def lookup_ancestors(g)
    bracket_data.vertices_dict.fetch(g.label).map do |l|
      lookup_node(l)
    end
    # begin
    #   init_lookups if @bracket_ancestors.nil?
    #   r= Set.new
    #   @bracket_ancestors[g.label].each do |a|
    #     r << lookup_node(a)
    #   end
    #   r
    # rescue KeyError
    #   nil
    # rescue => other_error
    #   raise BadProgrammerError(other_error)
    # end
  end

  def update_node(content, node)
    # old_content= @lookup_by_label[node]
    @lookup_by_label[node]= content
    content
  end

  def eql?(o)
    unless self.class.eql?(o.class)
      return false
    end
    initialization_data.zip(o.initialization_data).all? do |a|
      a[0].eql? a[1]
    end
  end

  def games_by_label
    games.order('label').to_a
  end

  def init_lookups
    init_lookup_by_label if lookup_by_label_uninitialized?
    init_ancestors
    init_relationships
  end

  def to_json_client_string
    init_lookups
    as_json_client_data.to_json
  end

  def lookup_by_label_uninitialized?
    lookup_by_label.nil? || lookup_by_label.empty?
  end

  def to_json_ancestor_lookup_string
    if bracket_ancestors.nil? or bracket_ancestors.empty?
      init_lookups
    end
    @bracket_ancestors.to_json
  end

  def newest_game_date
    # TODO: turn this into a SQL statement on the bracket returning the most
    # recent game
    Game.where(bracket_id: id)
  end

  def bracket_data
    @bracket_data||= BracketFactory.instance.serialized_bracket.copy
  end
  private

  attr :lookup_by_label, :bracket_ancestors

  def init_ancestors
    if @bracket_ancestors.nil? or @bracket_ancestors.empty?
      @bracket_ancestors = Hash.new { |h, k| h[k]= SortedSet.new }
      bracket_data.edges.each do |e|
        @bracket_ancestors[e.source] << e.target
      end
    end
  end

  def init_lookup_by_label
    if lookup_by_label_uninitialized?
      @lookup_by_label||= Hash.new
      if id.nil? or games.empty?
        init_lookups_from_template
      else
        init_lookups_from_database
      end
    end
  end

  def init_lookups_from_template
    bracket_data.vertices.each do |v|
      g = bracket_data.label_lookup.fetch v
      @lookup_by_label[g.label.to_s]= g
    end
  end

  def init_lookups_from_database
    if lookup_by_label_uninitialized?
      @lookup_by_label||= Hash.new
      self.games.each do |g|
        @lookup_by_label[g.label]= g
      end
      Team.all.each do |t|
        @lookup_by_label[t.label]= t
      end
    end
    init_ancestors unless bracket_data.nil?
  end

  def init_relationships
    game_ids=[]
    games=[]
    lookup_by_label.each_value do |v|
      if v.is_a? Game
        if v.id.nil?
          v.save!
        end
        game_ids<< v.id
        games<< v
      end
    end
    if self.id.nil?
      self.games= games
    else
      Game.where(id: game_ids).update_all(bracket_id: self.id)
    end
  end

  # part of the to_json_client_string pile
  def nodes
    r= Array.new
    bracket_data.vertices.each do |v|
      r<< lookup_by_label[v].as_json_client_data
    end
    r
  end
end


