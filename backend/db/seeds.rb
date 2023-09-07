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

book4 = Book.create!(name: "サンプル参考書4",
                    author: "サンプル著者4",
                    publisher: "サンプル出版社4",
                    subject: "英作文",
                    description: "サンプル参考書4の説明文",
                    user_id: user2.id
                  )

book5 = Book.create!(name: "日本の歴史1",
                    author: "日本史一郎",
                    publisher: "日本出版",
                    subject: "日本史",
                    description: "説明文",
                    user_id: user.id
                  )

book6 = Book.create!(name: "日本の歴史2",
                    author: "日本史二郎",
                    publisher: "日本出版",
                    subject: "日本史",
                    description: "説明文",
                    user_id: user.id
                  )

book7 = Book.create!(name: "日本の歴史3",
                    author: "日本史三郎",
                    publisher: "日本出版",
                    subject: "日本史",
                    description: "説明文",
                    user_id: user.id
                  )

book8 = Book.create!(name: "日本の歴史4",
                    author: "日本史四郎",
                    publisher: "日本出版",
                    subject: "日本史",
                    description: "説明文",
                    user_id: user.id
                  )

book9 = Book.create!(name: "英文法の教科書",
                    author: "英文法極め太郎",
                    publisher: "個人出版",
                    subject: "英文法",
                    description: "説明文",
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

review5 = Review.create!(rating: 5,
                        title: "サンプルレビュータイトル5",
                        content: "サンプルレビュー本文5",
                        user_id: user.id,
                        book_id: book5.id
                      )

review6 = Review.create!(rating: 2,
                        title: "サンプルレビュータイトル6",
                        content: "サンプルレビュー本文6",
                        user_id: user.id,
                        book_id: book6.id
                      )

review7 = Review.create!(rating: 2,
                        title: "サンプルレビュータイトル7",
                        content: "サンプルレビュー本文7",
                        user_id: user.id,
                        book_id: book6.id
                      )

review8 = Review.create!(rating: 2,
                        title: "サンプルレビュータイトル8",
                        content: "サンプルレビュー本文8",
                        user_id: user.id,
                        book_id: book6.id
                      )

review9 = Review.create!(rating: 2,
                        title: "サンプルレビュータイトル9",
                        content: "サンプルレビュー本文9",
                        user_id: user.id,
                        book_id: book6.id
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
question3 = Question.create!(title: "サンプル質問タイトル3",
                            content: "サンプル質問本文3",
                            subject: "英文法",
                            user_id: user.id,
                            book_id: book.id
                          )

question4 = Question.create!(title: "サンプル質問タイトル4",
                            content: "サンプル質問本文4",
                            subject: "英文法",
                            user_id: user.id,
                            book_id: book3.id
                          )

question5 = Question.create!(title: "英語の質問1",
                            content: "to不定詞の使い方を教えてください",
                            subject: "英文法",
                            user_id: user.id,
                            book_id: book9.id
                          )

question6 = Question.create!(title: "英語の質問2",
                            content: "動名詞の使い方を教えてください",
                            subject: "英文法",
                            user_id: user.id,
                            book_id: book9.id
                          )

question7 = Question.create!(title: "英語の質問3",
                            content: "分詞構文の使い方を教えてください",
                            subject: "英文法",
                            user_id: user.id,
                            book_id: book9.id
                          )

question8 = Question.create!(title: "英語の質問4",
                            content: "受動態の使い方を教えてください",
                            subject: "英文法",
                            user_id: user.id,
                            book_id: book9.id
                          )

reply = Reply.create!(content: "サンプル返信本文1",
                      user_id: user.id,
                      question_id: question.id
                    )

reply2 = Reply.create!(content: "サンプル返信本文2",
                        user_id: user2.id,
                        question_id: question.id
                      )

reply3 = Reply.create!(content: "英語の返信1",
                      user_id: user.id,
                      question_id: question5.id
                    )

reply4 = Reply.create!(content: "英語の返信2",
                      user_id: user.id,
                      question_id: question5.id
                    )

reply5 = Reply.create!(content: "英語の返信3",
                      user_id: user.id,
                      question_id: question5.id
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

subject_question3 = SubjectQuestion.create!(title: "サンプル科目別質問タイトル3",
                                            content: "サンプル科目別質問本文3",
                                            subject: "リスニング",
                                            user_id: user2.id
                                          )

subject_question4 = SubjectQuestion.create!(title: "英語の科目別質問1",
                                      content: "to不定詞の使い方を教えてください",
                                      subject: "英文法",
                                      user_id: user.id,
                                    )

subject_question5 = SubjectQuestion.create!(title: "英語の科目別質問2",
                                            content: "動名詞の使い方を教えてください",
                                            subject: "英文法",
                                            user_id: user.id,
                                          )

subject_question6 = SubjectQuestion.create!(title: "英語の科目別質問3",
                                            content: "分詞構文の使い方を教えてください",
                                            subject: "英文法",
                                            user_id: user.id,
                                          )

subject_question7 = SubjectQuestion.create!(title: "英語の科目別質問4",
                                            content: "受動態の使い方を教えてください",
                                            subject: "英文法",
                                            user_id: user.id,
                                            created_at: Time.now + 10.minute
                                          )

subject_question8 = SubjectQuestion.create!(title: "編集用科目別質問",
                                            content: "編集前科目別質問本文",
                                            subject: "その他科目",
                                            user_id: user.id,
                                          )

subject_question9 = SubjectQuestion.create!(title: "編集失敗用科目別質問",
                                            content: "編集失敗用科目別質問本文",
                                            subject: "その他科目",
                                            user_id: user.id,
                                          )

subject_question10 = SubjectQuestion.create!(title: "削除用科目別質問",
                                            content: "削除用科目別質問本文",
                                            subject: "その他科目",
                                            user_id: user.id,
                                          )

subject_question11 = SubjectQuestion.create!(title: "削除失敗用科目別質問",
                                            content: "削除失敗用科目別質問本文",
                                            subject: "その他科目",
                                            user_id: user.id,
                                          )

subject_question12 = SubjectQuestion.create!(title: "他ユーザー投稿科目別質問タイトル",
                                            content: "他ユーザー投稿科目別質問本文",
                                            subject: "その他科目",
                                            user_id: user2.id,
                                          )


subject_question_reply = SubjectQuestionReply.create!(content: "サンプル科目別返信本文1",
                                                      user_id: user.id,
                                                      subject_question_id: subject_question.id
                                                    )

subject_question_reply2 = SubjectQuestionReply.create!(content: "サンプル科目別返信本文2",
                                                      user_id: user2.id,
                                                      subject_question_id: subject_question.id
                                                    )

subject_question_reply3 = SubjectQuestionReply.create!(content: "サンプル科目別返信本文3",
                                                      user_id: user2.id,
                                                      subject_question_id: subject_question6.id
                                                    )

subject_question_reply4 = SubjectQuestionReply.create!(content: "サンプル科目別返信本文4",
                                                      user_id: user2.id,
                                                      subject_question_id: subject_question6.id
                                                    )

subject_question_reply5 = SubjectQuestionReply.create!(content: "サンプル科目別返信本文5",
                                                      user_id: user2.id,
                                                      subject_question_id: subject_question6.id
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

favorite_book2 = FavoriteBook.create!(user_id: user.id,
                                      book_id: book7.id
                                    )

favorite_book3 = FavoriteBook.create!(user_id: user2.id,
                                      book_id: book7.id
                                    )

favorite_book4 = FavoriteBook.create!(user_id: user3.id,
                                      book_id: book7.id
                                    )

favorite_review = FavoriteReview.create!(user_id: user2.id,
                                          review_id: review.id
                                        )

favorite_question = FavoriteQuestion.create!(user_id: user2.id,
                                              question_id: question.id
                                            )

favorite_question2 = FavoriteQuestion.create!(user_id: user.id,
                                              question_id: question6.id
                                            )

favorite_question3 = FavoriteQuestion.create!(user_id: user2.id,
                                              question_id: question6.id
                                            )

favorite_question4 = FavoriteQuestion.create!(user_id: user3.id,
                                              question_id: question5.id
                                            )

favorite_reply = FavoriteReply.create!(user_id: user2.id,
                                        reply_id: reply.id
                                      )

favorite_reply2 = FavoriteReply.create!(user_id: user2.id,
                                        reply_id: reply3.id
                                      )

favorite_subject_question = FavoriteSubjectQuestion.create!(user_id: user2.id,
                                                            subject_question_id: subject_question.id
                                                            )

favorite_subject_question2 = FavoriteSubjectQuestion.create!(user_id: user2.id,
                                                            subject_question_id: subject_question5.id
                                                            )

favorite_subject_question3 = FavoriteSubjectQuestion.create!(user_id: user3.id,
                                                            subject_question_id: subject_question5.id
                                                            )


favorite_subject_question_reply = FavoriteSubjectQuestionReply.create!(user_id: user2.id,
                                                                        subject_question_reply_id: subject_question_reply.id
                                                                      )


favorite_survey = FavoriteSurvey.create!(user_id: user2.id,
                                          survey_id: survey.id
                                        )


