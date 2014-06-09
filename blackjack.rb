class Card
  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end # initialize

  def rank
    @rank
  end # rank

  def suit
    @suit
  end # suit

  def to_s
    print @rank.to_s
    print ' '
    print @suit.to_s
    print ' '
  end # to_s

  def value
    case rank
    when :A then 1
    when :K, :Q, :J then 10
    else rank
    end # case rank
  end # value
end # card

# card = Card.new(rank, suit)
# p card # show me card.inspect
# puts card # show me card.to_s
# print card

class Deck
  def initialize
    @suits = [:clubs, :diamonds, :hearts, :spades]
    @deck = []
    run
  end # initalize

  def run
    create_deck
    shuffle
  end # run

  def deck
    @deck
  end # deck

  def create_deck #this method gives you all 13 cards from 1 suit
    # when index = 0 suits[index] = clubs
    # then adds 1 to the index and goes to the next suit
    # until it goes through all 4 suits.
    index = 0
    while index < 4
      @deck.push(Card.new(:A, @suits[index]))
      @deck.push(Card.new(2, @suits[index]))
      @deck.push(Card.new(3, @suits[index]))
      @deck.push(Card.new(4, @suits[index]))
      @deck.push(Card.new(5, @suits[index]))
      @deck.push(Card.new(6, @suits[index]))
      @deck.push(Card.new(7, @suits[index]))
      @deck.push(Card.new(8, @suits[index]))
      @deck.push(Card.new(9, @suits[index]))
      @deck.push(Card.new(10, @suits[index]))
      @deck.push(Card.new(:J, @suits[index]))
      @deck.push(Card.new(:Q, @suits[index]))
      @deck.push(Card.new(:K, @suits[index]))
      index += 1
    end # while
  end # create_deck

  def shuffle
    @deck.shuffle!
  end # shuffle

  def draw
    @deck.pop
  end # draw and goes to create_deck
end # class

# d = Deck.new
# puts d.deck
#
# puts '-----------------'
#
# d.shuffle
# puts d.deck

class Player
  def initialize
    @hand = []
  end # initialize

  def hand
    @hand
  end # hand

  def add_card(card)
    @hand.push(card)
  end # add_card

  def black_jack?
    if ((total_value == 21) && (hand.size == 2))
      black_jack = true
    else
      black_jack = false
    end # if
    black_jack
  end # black_jack

  def total_value
    total = 0
    for card in @hand
      total = total + card.value
      #  or total += card.value
    end # for each card
    total
  end # total_value

  def print_hand
    for card in @hand
      print card.to_s
    end # for_each
  end # print_hand
end # player

# this is me creating a new Player object and testing some Player methods

# p=Player.new
# p.add_card(Card.new(:A, :clubs))
# p.add_card(Card.new(8, :spades))
# puts p.total_value

# or option 2 below which are the same thing but assigns variables to the Card
# objects, and passes the Card objects to Player.add_card

# player = Player.new
# card_one = Card.new(:A, :clubs)
# card_two = Card.new(8, :spades)
# player.add_card(card_one)
# player.add_card(card_two)
# puts player.total_value

class Game
  def initialize
    @p1 = Player.new
    @house = Player.new
    #@bet = bet.new
    @deck = Deck.new
    run
  end # initialize

  def run
    puts "Welcome to Blackjack!! Good Luck players!!"
    initial_deal
    house_blackjack
  end # run

  def initial_deal
    @p1.add_card(@deck.draw)
    @house.add_card(@deck.draw)
    @p1.add_card(@deck.draw)
    @house.add_card(@deck.draw)
  end # initial_deal

  # def ace_value
  #   if total_value < 11
  #     :A == 11
  #     black_jack?
  #   else
  #     :A == 1
  #   end
  # end # ace_value

  def house_blackjack
    if @house.black_jack? # total_value == @house.black_jack
      puts "I am sorry, the house has Blackjack so you LOSE!!"
      game_over
    else
      human_play
    end # if
  end # house_blackjack

  def house_play
    print "The House has "
    @house.print_hand
    print "for a total of #{@house.total_value}! "
    if @house.total_value > 16 && @house.total_value < 22
      puts "House will stay with #{@house.total_value}!"
      game_over
    elsif @house.total_value <= 16
      puts "House will take a card"
      house_hit
    elsif @house.total_value > 21
      puts "House has busted, YOU WIN!!"
      game_over
    elsif @house.total_value == 21
      puts "House has 21 and will stay!!"
    else
      puts "The house will stay with #{@house.total_value}"
      game_over
    end # if
  end # house_play

  def human_play
    print "You have "
    @p1.print_hand
    print "for a total of #{@p1.total_value}! "
    if @p1.black_jack?
      puts "Congratulations Blackjack Winner!!"
      house_play
    elsif @p1.total_value < 21
      puts "Would you like to Hit or Stay?"
      input = gets.chomp.downcase
      if input == "hit"
        puts "You will take a new card."
        p1_hit
        human_play
      else
        puts "You will stay with #{@p1.total_value}!"
        house_play
      end # if input
    elsif @p1.total_value > 21
      puts "You have BUSTED player!!"
      game_over
    elsif @p1.total_value == 21
      puts "You have 21 and will stay!!"
      house_play
    else
      house_play
    end # if
  end # human_play

  def house_hit
    @house.add_card(@deck.draw)
    house_play
  end # house_hit

  def p1_hit
    @p1.add_card(@deck.draw)
  end # p1_hit

  def game_over
    if @house.total_value > 21
      puts "Thank you for playing!!"
      exit
    elsif @p1.total_value > 21
      puts "Thank you for playing!!"
      exit
    elsif @house.total_value == @p1.total_value
      puts "We have a push!!  Nobody wins or loses."
      puts "Thank you for playing!!"
      exit
    elsif @house.total_value > @p1.total_value
      puts "You lose!! Dealer has #{@house.total_value}!"
      puts "Thank you for playing!!"
      exit
    else @house.total_value < @p1.total_value
      puts "You WIN!!!  You have #{@p1.total_value}"
      puts "Thank you for playing!!"
      exit
    end # if
    exit
  end # game_over
end # game

Game.new
