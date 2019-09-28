require "byebug"

require "set"
require_relative "./player.rb"


class GhostGame
  ALPHABET = Set.new("a".."z")
  GHOST = ["G", "H", "O", "S", "T"]
  MAX_LOSS_COUNT = 5

  attr_reader :dictionary, :players, :losses

  def initialize(*players)
    words = File.readlines("./words.txt").map(&:chomp)
    @dictionary = Set.new(words)
    @players = players
    @losses = Hash.new { |losses, player| losses[player] = 0 }
    @fragment = ""
  end

  def run
    play_round until game_over?
    @players.each do |player|
      print "#{player.name} has #{player.ghost.join('')}\n"
    end
    print "#{current_player.name} Wins!"
  end

  def play_round
    @players.each do |player|
      print "#{player.name} has #{player.ghost.length} GHOST letters\n"
    end
    take_turn
  end

  def game_over?
    previous_player.ghost.length == GHOST.length
  end

  def take_turn
    sleep(2)
    system("clear")
    print "\n\n#{current_player.name} it is your turn!\n"
    print "The current fragment is \"#{@fragment}\"\n"
    print "Good Luck!\n"
    letter_guess = current_player.get_guess
    while !valid_guess?(letter_guess)
      current_player.alert_invalid_guess
      letter_guess = current_player.get_guess
    end

    add_letter_to_fragment(letter_guess)
    if is_a_fragment?(@fragment)
      if is_a_word?(@fragment)
        sleep(2)
        system("clear")
        print "\nSorry, #{current_player.name}\n"
        print "Your guess completed a word.\n"
        print "Your guess made the word #{@fragment}\n\n"
        lost_round
      end
    else
      sleep(2)
      system("clear")
      print "\nSorry, #{current_player.name}\n"
      print "Your guess didn't add to a real word.\n"
      print "Your guess made the fragment #{@fragment}\n\n"
      lost_round
    end
    next_player
  end

  def lost_round
    sleep(2)
    system("clear")
    # add ghost letter to players ghost letter count
    letter_to_get = current_player.ghost.length
    print "You get a #{GHOST.slice(letter_to_get...letter_to_get + 1)}\n"
    current_player.add_ghost_letter(GHOST.slice(letter_to_get...letter_to_get + 1))
    print "You now have #{current_player.ghost.join('')}\n"
    @fragment = ""
  end

  def is_a_fragment?(fragment)
    @dictionary.each { |word| return true if word.start_with?(fragment) }
    false
  end

  def is_a_word?(fragment)
    @dictionary.each do |word|
     if word == fragment
      print "\n\nword: #{word} and fragment: #{fragment}\n\n"
      return true
     end
    end
    false
  end

  def add_letter_to_fragment(letter)
    @fragment << letter
  end

  def valid_guess?(letter)
    ALPHABET.include?(letter)
  end
  
  def current_player
    players.first
  end

  def previous_player
    players.last
  end

  def next_player
    players.push(players.shift)
  end

  # UI methods (display game status and prompts to players)

end

if __FILE__ == $PROGRAM_NAME
  print "How many players are there: "
  num_of_players = gets.chomp.to_i
  players_list = []
  num_of_players.times { 
    print "Welcome new player!\n"
    print "Enter your name: "
    name = gets.chomp
    players_list << Player.new(name)
    print "Who's next?\n\n"
  }
  game = GhostGame.new(
    *players_list
    # Player.new("Gizmo"),
    # Player.new("Breakfast"),
    # Player.new("Toby"),
    # Player.new("Leonardo")
  )

  game.run
end