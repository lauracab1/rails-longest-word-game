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
    @response = if in_the_grid?(@letters, @word)
                  "Sorry but #{@word} can't be built out of #{@letters.gsub(' ', ', ')}"
                elsif english_word?(@word) == false
                  "Sorry but #{@word} doesn't not seem to be a valid English word"
                else
                  "Congratulations! #{@word} is a valid English word!"
                end
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
