class Player
  attr_reader :name, :ghost

  def initialize(name)
    @name = name
    @ghost = []
  end

  def get_guess
    ask_for_guess
    gets.chomp
  end

  def ask_for_guess
    print "Enter your guess.\n"
    print "Choose a letter from the alphabet: "
  end

  def alert_invalid_guess
    print "You made an invalid guess.\n"
    print "Please try again."
  end

  def add_ghost_letter(ghost_letter)
    ghost << ghost_letter
  end
end