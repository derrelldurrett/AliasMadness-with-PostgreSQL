module AdminHelper
  def build_scenarios
    ref = @user.bracket
    ref = ref.clone
    to_choose = ref.games.select {|g| g.winner.nil?}.sort_by {|g| -g.label.to_i}.to_a
    # chose all but last, choose 1, then the othercurrent_score
    puts "SIZE: #{to_choose.length}"
    @scenarios = []
    choose_both_winners ref, to_choose
  end

  def choose_both_winners(ref, to_choose, i = 0)
    puts "index to start from: #{i}"
    if to_choose.length == i
      result = compute_scores_for_scenario ref
      @scenarios << {scenario: capture_winners(to_choose), result: result}
    else
      to_choose[i..-1].each do |g|
        ref.lookup_ancestors(g).sort_by(&:label).each do |a|
          g.winner = a.winner
          choose_both_winners ref, to_choose, i + 1
        end
      end
    end
    @scenarios
  end

  def capture_winners(games_to_scrape)
    games_to_scrape.each_with_object({}) do |g, by_round|
      round_key = "Round #{g.round}"
      by_round[round_key] = [] unless by_round[round_key].is_a? Array
      by_round[round_key] << g.winner
    end
  end

  def compute_scores_for_scenario(ref)
    @players.each {|p| p.score ref}
  end
end
