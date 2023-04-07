class QuestionsController < ApplicationController

  def index
    questions = Question.all
    if questions
      render json: questions
    else
      render json: questinos.errors
    end
  end

end
