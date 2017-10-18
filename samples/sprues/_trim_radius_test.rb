require 'squib'

Squib::Deck.new(cards: 9) do
  background color: :white
  rect stroke_width: 5, stroke_color: :red
  cut_zone margin: '0.125in', 
           stroke_width: 2, stroke_color: :purple
  text str: (0..9).map{ |i| "Card #{i}\n2.5x3.5in" },
       font: 'Sans 32', align: :center, valign: :middle,
       height: :deck, width: :deck
  save_sheet sprue: 'letter_poker_card_9up.yml',
             trim: '0.125in', # NOTE THIS
             prefix: "sprue_trim_radius_example_"
end
