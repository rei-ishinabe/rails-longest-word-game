require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @input = params[:input].upcase
    @letters = params[:letters]
    @point = @input.length
    @total_score = 0
    json = open("https://wagon-dictionary.herokuapp.com/#{@input}").read
    if !in_grid?(@input, @letters)
      @result = 'not in the grid'
    elsif !JSON.parse(json)["found"]
      @result = 'not an english word'
    elsif session[:total_score].nil?
      @total_score = @point
      @result = "You've got #{@point} points! (Total: #{@total_score} points)"
      session[:total_score] = @point
    else
      @total_score = session[:total_score] + @point
      @result = "You've got #{@point} points! (Total: #{@total_score} points)"
      session[:total_score] += @point
    end
  end

  private

  def in_grid?(input, letters)
    letters_hash = Hash.new(0)
    letters.split('').each { |letter| letters_hash[letter] += 1 }
    input_hash = Hash.new(0)
    input.split('').each { |letter| input_hash[letter] += 1 }
    input_hash.all? { |key, _| input_hash[key] <= letters_hash[key] }
  end
end
