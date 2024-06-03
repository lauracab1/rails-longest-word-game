require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = 10.times.map { Array('A'..'Z').sample }
    @letters
  end

  def score
    @score = 0
    @letters = params[:letters]
    @word = params[:word]

    if in_the_grid?(@letters, @word)
      @response = "it's not in the grid"
    else
      @response = "it's ok"
    end

    if english_word?(@word)
      @score += 1
    end
  end

  private

  def in_the_grid?(letters, word)
    word = word.upcase.split('')
    result = []
      word.each do |letter|
        result << letters.include?(letter)
      end
    result.include?(false)
  end

  def english_word?(word)
    response = URI.parse("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
