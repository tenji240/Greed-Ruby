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
    print "Rolls: #{array.inspect} -"
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

    print "Total Scoring Die: #{total_die}\n"
    print "Total Non-Scoring Die: #{@values.count - total_die}\n"
    return @values.count - total_die
  end

end


def game(players)

  players.each_with_index { |player, index|
    print "Player #{index} now rolling\n"
    turn_score = 0
    player_score = 0
    die = 5

    #begin initial round
    player.roll(die)
    if player.score >= 300 #pass min threshold
      while(player.score != 0) do

        turn_score += player.score
        print " Round Score: #{player.score}\n"

        print "Would you like to continue (Y-N): "
        input = gets.chomp
        input.upcase!
        if input == "N"
          player_score += turn_score
          break
        end

        print "\n\tCurrent Turn Score: #{turn_score}\n"
        if player.die_remaining == 0
          die = 5
        else
          die = player.die_remaining
        end

        player.roll(die)

      end
    else
      print " Round Score: #{player.score}\n"
    end

    player.player_final_score += player_score
    print "\nFinal Score for Player #{index}: #{player.player_final_score}\n\n"
  }
  print "......End of Round......\n\n"
end

#for a player to start
players = [DiceSet.new, DiceSet.new]
continue = true
game(players)

while continue do
  
  players.each_with_index { |player, index| 
    print "Player #{index} score: #{player.player_final_score}\n"
    if player.player_final_score >= 3000
      continue = false
      break
    end
  }
  print "\n"
  game(players)
end

print "\n.......Final Round........\n"
game(players) #play final round
print "\n----Final Score---\n"
players.each_with_index { |player, index| print "Player #{index}: #{player.player_final_score}\n" }





