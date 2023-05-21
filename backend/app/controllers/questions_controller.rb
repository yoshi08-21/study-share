class QuestionsController < ApplicationController

  def index
    book = Book.find_by(id: params[:book_id])
    questions = book.questions.includes(:user)
    if questions
      render json: questions, include: "user"
    else
      render json: questinos.errors
    end
  end

  def show
    book = Book.find_by(id: params[:book_id])
    question = Question.includes(:user).find_by(id: params[:id])
    if question
      render json: {
        book: book,
        question: question.as_json(include: :user)
      }
    else
      render json: question.errors
    end
  end


end
