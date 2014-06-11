class Card
  # attr_accessor :rank, :suit (this does same thing as code on lines 9-15)

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
  attr_accessor :hand, :bet

  def initialize
    @hand = []
    @bet = Money.new
  end # initialize

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
    num_of_aces = 0
    for card in @hand
      if card.rank == :A
        num_of_aces = num_of_aces + 1
      end # if
    end #for card in hand
    for card in @hand
      total = total + card.value
      #  or total += card.value
    end # for each card
    if total <= 11 && num_of_aces > 0
      total = total + 10
    end # if
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

class Money
  attr_accessor :wallet, :bets

  def initialize
    @wallet = 100
    @bets = 0
  end # initialize

  def bet_amt
    @bets = gets.chomp.to_i
  end # bets

  def lose_bet
    @wallet -= @bets
  end

  def win_bet
    @wallet += @bets
  end
end # money

class Game
  def initialize
    @p1 = Player.new
    @house = Player.new
    @deck = Deck.new
    run
  end # initialize

  def run
    puts "Welcome to Blackjack!! Good Luck players!!"
    if @p1.bet.wallet > 9
      puts "Please bet minimum of $10. You have $#{@p1.bet.wallet}"
    else
      game_over
    end
    @p1.bet.bet_amt
    initial_deal
    house_blackjack
  end # run

  def initial_deal
    @p1.hand = []
    @house.hand =[]
    @p1.add_card(@deck.draw)
    @house.add_card(@deck.draw)
    @p1.add_card(@deck.draw)
    @house.add_card(@deck.draw)
  end # initial_deal

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
    puts "Dealer has #{@house.total_value}."
    if @p1.black_jack?
      puts "Congratulations Blackjack Winner!!"
      @p1.bet.win_bet
      house_play
    elsif @p1.total_value < 21
      puts "Would you like to (H)it or (S)tay?"
      input = gets.chomp.downcase
      if input == "h"
        puts "You will take a new card."
        p1_hit
        human_play
      else
        puts "You will stay with #{@p1.total_value}!"
        house_play
      end # if input
    elsif @p1.total_value > 21
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
      puts "House has busted, YOU WIN!!"
      @p1.bet.win_bet
    elsif @p1.total_value > 21
      puts "You have BUSTED player!!  House wins with #{@house.total_value}!"
      @p1.bet.lose_bet
    elsif @house.total_value == @p1.total_value
      puts "We have a push!!  Nobody wins or loses."
    elsif @house.total_value > @p1.total_value
      @p1.bet.lose_bet
      puts "You lose!! Dealer has #{@house.total_value}!"
    else @house.total_value < @p1.total_value
      @p1.bet.win_bet
      puts "You WIN!!!  You have #{@p1.total_value}"
    end # if
    if @p1.bet.wallet < 10
      puts "Sorry you are out of money."
      puts "Thank you for playing!!"
      exit
    else
      puts "Would you like to play again?  (Y)es or (N)o?"
      keep_playing = gets.chomp.downcase
      if keep_playing == "y"
        puts "Great!!  Let's keep playing"
        run
      else
        puts "Thank you for playing!!"
        exit
      end
    end #if
  end # game_over
end # game

Game.new
