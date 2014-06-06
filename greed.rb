require 'test/unit'

class DiceSet

  attr_reader :values
  attr_accessor :player_score
  attr_accessor :turn_score
  attr_accessor :player_final_score

  def initialize
    @values = []
    @player_final_score = 0
  end

  def roll(num)
    array = []
    num.times do |n| array.push( 1 + rand(6) ) end
    puts "Rolls: #{array.inspect} -"
    @values = array
  end

  def score
    # You need to write this method
    sum = 0
    @values.group_by {|i| i}.each {|key, value|
      if key == 1
        sum += 1000 * (value.count / 3) + 100 * (value.count % 3)
      elsif key == 5
        sum += 50 * (value.count % 3) + (100 * (value.count / 3) * key)
      else
        sum += 100 * (value.count / 3) * key
      end
    }
    return sum
  end
  
  def die_remaining #all the scoring die
    total_die = 0
    
    @values.group_by {|i| i}.each {|key, value|
        if (key == 1) || (key == 5)
          total_die += value.count
        elsif value.count >= 3
          total_die += 3
        end
      }

    puts "Total Scoring Die: #{total_die}"
    puts "Total Non-Scoring Die: #{@values.count - total_die}"
    return @values.count - total_die
  end

end


def game(players)

  players.each_with_index do |player, index|
    puts "Player #{index} now rolling"
    turn_score = 0
    player_score = 0
    die = 5

    #begin initial round
    player.roll(die)
    if (player.score >= 300) || (player.player_final_score >= 300) #pass min threshold
      while(player.score != 0) do

        turn_score += player.score
        puts "Round Score: #{player.score}"

        puts "Would you like to continue?(Yn): "
        input = gets.chomp
        if input.upcase! == "N"
          puts "Score Added: #{turn_score}"
          player_score += turn_score
          break
        end

        puts "Current Turn Score: #{turn_score}"
        if player.die_remaining == 0
          die = 5
        else
          die = player.die_remaining
        end

        player.roll(die)

      end
    else
      puts "Round Over :(\n "
    end
    player.player_final_score += player_score
  end
  puts "......End of Round......\n "
end

#for a player to start
players = [DiceSet.new, DiceSet.new]
is_final_round = false

while !is_final_round do
  
  players.each_with_index { |player, index| 
    puts "Player-#{index} score: #{player.player_final_score}"
    if player.player_final_score >= 3000
      is_final_round = true
      break
    end
  }
  game(players)
end

puts ".......Final Round........"
game(players) #play final round
puts "----Final Score---"
players.each_with_index { |player, index| puts "Player-#{index} Final Score: #{player.player_final_score}" }





