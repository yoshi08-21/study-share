class SubjectQuestionsController < ApplicationController

  def index
    subject_questions = SubjectQuestion.all
    if subject_questions
      render json: subject_questions
    else
      render json: subject_questions.errors
    end
  end
end
