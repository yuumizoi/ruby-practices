#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

score_string = ARGV[0]
game = Game.new(score_string)
puts game.calculate_total_score
