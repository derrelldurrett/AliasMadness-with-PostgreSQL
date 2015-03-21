require 'helpers/hash_helper'
require 'helpers/hash_class_helper'
require 'helpers/json_client_helper'
require 'helpers/json_client_class_helper'
class Game < ActiveRecord::Base
  include HashHelper
  extend HashClassHelper
  include JSONClientHelper
  extend JSONClientClassHelper
  belongs_to :team, inverse_of: :games
  belongs_to :bracket, inverse_of: :games
  attr_accessible :label, :winner

  serialize :team, Team

  self.hash_vars= %i(id team bracket label)
  self.json_client_ids= [:id, :label, :winner, :winners_label]
  def to_s
    to_json
  end

  def eql?(other)
    other.is_a?(Game) and label.eql? other.label and bracket.eql? other.bracket
  end
  alias == eql? # This was necessary to get the
                # comparisons to work (even though it
                # shouldn't have mattered?)

  alias winner team
  alias winner= team=

  def winners_label
    winner.nil? ? nil : winner.label
  end

                # refactor this to be a callback from the Score module?
  def round_multiplier
    # *Really* need to make this a property of the game at the time it's created
    case label.to_i
      when 1
        64
      when 2..3
        32
      when 4..7
        16
      when 8..15
        8
      when 16..31
        4
      when 32..63
        2
    end
  end

end
