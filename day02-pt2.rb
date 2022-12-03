class Round
  WINNER_FOR = {
    :rock => :paper,
    :paper => :scissors,
    :scissors => :rock,
  }
  LOSER_FOR = {
    :rock => :scissors,
    :paper => :rock,
    :scissors => :paper,
  }

  def initialize(opponent_shape_code:, my_shape_code:)
    @opponent_shape_code = opponent_shape_code
    @my_shape_code = my_shape_code
  end

  def my_score
    score = 0

    if i_won?
      score += 6
    elsif draw?
      score += 3
    end

    case my_shape
    when :rock then score += 1
    when :paper then score += 2
    when :scissors then score += 3
    end
  end

  private

  def i_won?
    game_result == :won
  end

  def draw?
    game_result == :draw
  end

  def game_result
    @game_result ||= begin
      if my_shape == opponent_shape
        :draw
      else
        case my_shape
        when :rock then opponent_shape == :scissors ? :won : :lost
        when :paper then opponent_shape == :rock ? :won : :lost
        when :scissors then opponent_shape == :paper ? :won : :lost
        end
      end
    end
  end

  def my_shape
    case @my_shape_code
    when "X"
      LOSER_FOR[opponent_shape]
    when "Y"
      opponent_shape
    when "Z"
      WINNER_FOR[opponent_shape]
    else
      raise "Unknown shape code: #{@my_shape_code}"
    end
  end

  def opponent_shape
    case @opponent_shape_code
    when "A"
      :rock
    when "B"
      :paper
    when "C"
      :scissors
    else
      raise "Unknown shape code: #{@opponent_shape_code}"
    end
  end
end

rounds = File.readlines("day02.txt").map do |line|
  opponent_shape, my_shape = line.split(" ")
  Round.new(opponent_shape_code: opponent_shape, my_shape_code: my_shape)
end

puts rounds.sum(&:my_score)
