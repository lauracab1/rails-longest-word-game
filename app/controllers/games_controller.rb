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
    @in_the_grid = in_the_grid?(@letters, @word)
    @response = @in_the_grid ? "it's not ok" : "it's ok"
    @score += 1 if (@in_the_grid == false) && english_word?(@word)
  end

  private

  def in_the_grid?(letters, word)
    word = word.upcase.split('')
    result = []
    word.each do |letter|
      result << letters.include?(letter)
      result << (word.count(letter) <= letters.count(letter))
    end
    result.include?(false)
  end

  def english_word?(word)
    response = URI.parse("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
