# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create!(name: "cypress-sample",
                    email: "cypress@cypress.com",
                    uid: "W0kuhhA7rgRl0t4aITV4kdHB0Mq2",
                    first_choice_school: "A大学",
                    second_choice_school: "B大学",
                    third_choice_school: "C大学",
                    introduction: "よろしくお願いします",
                    memo: "参考書Aが気になる"
                  )

user2 = User.create!(name: "edit-cypress-sample",
                    email: "edit_cypress@cypress.com",
                    uid: "E50FoAkTBoVThtHQpZYiGOssT672",
                    first_choice_school: "D大学",
                    second_choice_school: "E大学",
                    third_choice_school: "F大学",
                    introduction: "頑張ります",
                    memo: "問題集Bを買う"
                  )

user3 = User.create!(name: "delete-cypress-sample",
                    email: "delete_cypress@cypress.com",
                    uid: "85ZtGMW50hTUhxHI96PbXVhJKvt2",
                    first_choice_school: "A大学",
                    second_choice_school: "B大学",
                    third_choice_school: "C大学",
                    introduction: "絶対合格しましょう",
                    memo: "単語帳Cを確認"
                  )

book = Book.create!(name: "サンプル参考書1",
                    author: "サンプル著者1",
                    publisher: "サンプル出版社1",
                    subject: "現代文",
                    description: "サンプル参考書1の説明文",
                    user_id: user.id
                  )

book2 = Book.create!(name: "サンプル参考書2",
                    author: "サンプル著者2",
                    publisher: "サンプル出版社2",
                    subject: "古文",
                    description: "サンプル参考書2の説明文",
                    user_id: user.id
                  )
book3 = Book.create!(name: "サンプル参考書3",
                    author: "サンプル著者3",
                    publisher: "サンプル出版社3",
                    subject: "漢文",
                    description: "サンプル参考書3の説明文",
                    user_id: user.id
                  )


review = Review.create!(rating: 5,
                        title: "サンプルレビュータイトル1",
                        content: "サンプルレビュー本文1",
                        user_id: user.id,
                        book_id: book.id
                      )

review2 = Review.create!(rating: 1,
                        title: "サンプルレビュータイトル2",
                        content: "サンプルレビュー本文2",
                        user_id: user2.id,
                        book_id: book.id
                      )

review3 = Review.create!(rating: 3,
                        title: "サンプルレビュータイトル3",
                        content: "サンプルレビュー本文3",
                        user_id: user.id,
                        book_id: book2.id
                      )

review4 = Review.create!(rating: 4,
                        title: "サンプルレビュータイトル4",
                        content: "サンプルレビュー本文4",
                        user_id: user.id,
                        book_id: book.id
                      )

question = Question.create!(title: "サンプル質問タイトル1",
                            content: "サンプル質問本文1",
                            subject: "英文法",
                            user_id: user.id,
                            book_id: book.id
                          )

question2 = Question.create!(title: "サンプル質問タイトル2",
                            content: "サンプル質問本文2",
                            subject: "英文法",
                            user_id: user2.id,
                            book_id: book.id
                          )

reply = Reply.create!(content: "サンプル返信本文1",
                      user_id: user.id,
                      question_id: question.id
                    )

reply2 = Reply.create!(content: "サンプル返信本文2",
                        user_id: user2.id,
                        question_id: question.id
                      )

subject_question = SubjectQuestion.create!(title: "サンプル科目別質問タイトル1",
                                            content: "サンプル科目別質問本文1",
                                            subject: "リスニング",
                                            user_id: user.id
                                          )

subject_question2 = SubjectQuestion.create!(title: "サンプル科目別質問タイトル2",
                                            content: "サンプル科目別質問本文2",
                                            subject: "リスニング",
                                            user_id: user2.id
                                          )

subject_question_reply = SubjectQuestionReply.create!(content: "サンプル科目別返信本文1",
                                                      user_id: user.id,
                                                      subject_question_id: subject_question.id
                                                    )

subject_question_reply2 = SubjectQuestionReply.create!(content: "サンプル科目別返信本文2",
                                                      user_id: user2.id,
                                                      subject_question_id: subject_question.id
                                                    )

survey = Survey.create!(title: "テストアンケートタイトル1",
                        content: "テストアンケート本文1",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "数学",
                        status: false,
                        user_id: user.id
                      )

survey2 = Survey.create!(title: "テストアンケートタイトル2",
                        content: "テストアンケート本文2",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "数学",
                        status: false,
                        user_id: user2.id
                      )

survey_answer = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user2.id,
                                      survey_id: survey.id
                                    )

survey_answer2 = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user.id,
                                      survey_id: survey2.id
                                    )

favorite_book = FavoriteBook.create!(user_id: user.id,
                                      book_id: book.id
                                    )

favorite_review = FavoriteReview.create!(user_id: user2.id,
                                          review_id: review.id
                                        )

favorite_question = FavoriteQuestion.create!(user_id: user2.id,
                                              question_id: question.id
                                            )

favorite_reply = FavoriteReply.create!(user_id: user2.id,
                                        reply_id: reply.id
                                      )


favorite_subject_question = FavoriteSubjectQuestion.create!(user_id: user2.id,
                                                            subject_question_id: subject_question.id
                                                            )


favorite_subject_question_reply = FavoriteSubjectQuestionReply.create!(user_id: user2.id,
                                                                        subject_question_reply_id: subject_question_reply.id
                                                                      )


favorite_survey = FavoriteSurvey.create!(user_id: user2.id,
                                          survey_id: survey.id
                                        )


