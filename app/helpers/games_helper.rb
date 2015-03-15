module GamesHelper
  def game_or_team_options_for_select(bracket,game)
    # produce a list of lists: [[object,display_value],...]
    result = ['Choose winner...']
    games_or_teams = bracket.lookup_ancestors(game).sort_by { |got| got.label }
    games_or_teams.each do |got|
      result << build_result_entry(got)
    end
    selected= game.winner.nil? ? nil : game.winner.label
    options_for_select result, selected
  end

  def build_result_entry(got)
    if got.is_a? Game
      got.winner.nil? ? ['', nil] :
          [got.winner.name, got.winner.label]
    else
      got.nil? ? ['', nil] : [got.name, got.label]
    end
  end

  def choose_winner_or(game)
    game.winner.nil? ? 'Choose winner...' : game.winner.name
  end

  def color_winner(game, node, bracket_locked)
    color= 'grey'
    if bracket_locked
      if game.winner.eliminated?
        color='red'
      end
      w = Admin.get.bracket.lookup_game(node).winner # maybe make this a route-driven lookup? For security purposes?
      unless w.nil?
        if game.winner== w
          color= 'green'
        end
      end
    end
    ' '+[color, 'winner_state'].join('_') # need a space in front
  end
end
