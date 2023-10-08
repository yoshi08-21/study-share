user = User.create!(name: "cypress-sample",
                    email: "cypress@cypress.com",
                    uid: "W0kuhhA7rgRl0t4aITV4kdHB0Mq2",
                    first_choice_school: "A大学",
                    second_choice_school: "B大学",
                    third_choice_school: "C大学",
                    introduction: "よろしくお願いします",
                    memo: "参考書Aが気になる",
                    activated: true,
                  )

user2 = User.create!(name: "edit-cypress-sample",
                    email: "edit_cypress@cypress.com",
                    uid: "E50FoAkTBoVThtHQpZYiGOssT672",
                    first_choice_school: "D大学",
                    second_choice_school: "E大学",
                    third_choice_school: "F大学",
                    introduction: "頑張ります",
                    memo: "問題集Bを買う",
                    activated: true,
                  )

user3 = User.create!(name: "delete-cypress-sample",
                    email: "delete_cypress@cypress.com",
                    uid: "85ZtGMW50hTUhxHI96PbXVhJKvt2",
                    first_choice_school: "A大学",
                    second_choice_school: "B大学",
                    third_choice_school: "C大学",
                    introduction: "絶対合格しましょう",
                    memo: "単語帳Cを確認",
                    activated: true,
                  )

user4 = User.create!(name: "sample-user1",
                    email: "sample@sample.com",
                    uid: "sample",
                    first_choice_school: "A大学",
                    second_choice_school: "B大学",
                    third_choice_school: "C大学",
                    introduction: "A",
                    memo: "A",
                    activated: true,
                  )


book = Book.create!(name: "サンプル参考書1",
                    author: "サンプル著者1",
                    publisher: "サンプル出版社1",
                    subject: "現代文",
                    description: "サンプル参考書1の説明文",
                    user_id: user.id,
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

book10 = Book.create!(name: "お気に入り用参考書1",
                      author: "お気に入り著者1",
                      publisher: "お気に入り出版1",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book11 = Book.create!(name: "お気に入り用参考書2",
                      author: "お気に入り著者2",
                      publisher: "お気に入り出版2",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book12 = Book.create!(name: "お気に入り用参考書3",
                      author: "お気に入り著者3",
                      publisher: "お気に入り出版3",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book13 = Book.create!(name: "お気に入り用参考書4",
                      author: "お気に入り著者4",
                      publisher: "お気に入り出版4",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book14 = Book.create!(name: "お気に入り登録用参考書1",
                      author: "お気に入り登録著者1",
                      publisher: "お気に入り登録出版1",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book15 = Book.create!(name: "お気に入り登録用参考書2",
                      author: "お気に入り登録著者2",
                      publisher: "お気に入り登録出版2",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book16 = Book.create!(name: "お気に入り登録用参考書3",
                      author: "お気に入り登録著者3",
                      publisher: "お気に入り登録出版3",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book17 = Book.create!(name: "お気に入り登録用参考書4",
                      author: "お気に入り登録著者4",
                      publisher: "お気に入り登録出版4",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book18 = Book.create!(name: "お気に入り解除用参考書1",
                      author: "お気に入り解除著者1",
                      publisher: "お気に入り解除出版1",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book19 = Book.create!(name: "お気に入り解除用参考書2",
                      author: "お気に入り解除著者2",
                      publisher: "お気に入り解除出版2",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book20 = Book.create!(name: "お気に入り解除用参考書3",
                      author: "お気に入り解除著者3",
                      publisher: "お気に入り解除出版3",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book21 = Book.create!(name: "お気に入り解除用参考書4",
                      author: "お気に入り解除著者4",
                      publisher: "お気に入り解除出版4",
                      subject: "過去問",
                      description: "説明文",
                      user_id: user.id
                    )

book22 = Book.create!(name: "閲覧履歴作成用参考書1",
                      author: "閲覧履歴作成用著者1",
                      publisher: "閲覧履歴作成用出版社1",
                      subject: "小論文",
                      description: "説明文",
                      user_id: user.id
                    )

book23 = Book.create!(name: "閲覧履歴作成用参考書2",
                      author: "閲覧履歴作成用著者2",
                      publisher: "閲覧履歴作成用出版社2",
                      subject: "小論文",
                      description: "説明文",
                      user_id: user.id
                    )

book24 = Book.create!(name: "通知作成用参考書1",
                      author: "通知作成用著者1",
                      publisher: "通知作成用出版社1",
                      subject: "小論文",
                      description: "説明文",
                      user_id: user.id
                    )

# bookを増やすとfavorite-book.cy.jsの一覧ページでのお気に入り追加のテストが壊れるので注意



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

review10 = Review.create!(rating: 1,
                        title: "いいね用レビュー1",
                        content: "いいね用レビュー本文1",
                        user_id: user4.id,
                        book_id: book10.id
                      )

review11 = Review.create!(rating: 1,
                        title: "いいね用レビュー2",
                        content: "いいね用レビュー本文2",
                        user_id: user4.id,
                        book_id: book10.id
                      )

review12 = Review.create!(rating: 1,
                        title: "いいね用レビュー3",
                        content: "いいね用レビュー本文3",
                        user_id: user4.id,
                        book_id: book10.id
                      )

review13 = Review.create!(rating: 1,
                        title: "いいね追加用レビュー1",
                        content: "いいね追加用レビュー本文1",
                        user_id: user4.id,
                        book_id: book14.id
                      )

review14 = Review.create!(rating: 1,
                        title: "いいね追加用レビュー2",
                        content: "いいね追加用レビュー本文2",
                        user_id: user4.id,
                        book_id: book14.id
                      )

review15 = Review.create!(rating: 1,
                        title: "いいね削除用レビュー1",
                        content: "いいね削除用レビュー本文1",
                        user_id: user4.id,
                        book_id: book18.id
                      )

review16 = Review.create!(rating: 1,
                        title: "いいね削除用レビュー2",
                        content: "いいね削除用レビュー本文2",
                        user_id: user4.id,
                        book_id: book18.id
                      )

review17 = Review.create!(rating: 1,
                        title: "閲覧履歴作成用レビュー1",
                        content: "閲覧履歴作成用レビュー1",
                        user_id: user4.id,
                        book_id: book22.id
                      )
review18 = Review.create!(rating: 1,
                        title: "閲覧履歴作成用レビュー2",
                        content: "閲覧履歴作成用レビュー2",
                        user_id: user4.id,
                        book_id: book22.id
                      )

review19 = Review.create!(rating: 1,
                        title: "通知作成用レビュー1",
                        content: "通知作成用レビュー本文1",
                        user_id: user.id,
                        book_id: book24.id
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

question9 = Question.create!(title: "いいね用質問1",
                            content: "いいね用質問本文1",
                            subject: "過去問",
                            user_id: user4.id,
                            book_id: book10.id
                          )

question10 = Question.create!(title: "いいね用質問2",
                              content: "いいね用質問本文2",
                              subject: "過去問",
                              user_id: user4.id,
                              book_id: book10.id
                            )

question11 = Question.create!(title: "いいね用質問3",
                              content: "いいね用質問本文3",
                              subject: "過去問",
                              user_id: user4.id,
                              book_id: book10.id
                            )

question12 = Question.create!(title: "いいね追加用質問1",
                              content: "いいね追加用質問本文1",
                              subject: "過去問",
                              user_id: user4.id,
                              book_id: book14.id
                            )

question13 = Question.create!(title: "いいね追加用質問2",
                              content: "いいね追加用質問本文2",
                              subject: "過去問",
                              user_id: user4.id,
                              book_id: book14.id
                            )

question14 = Question.create!(title: "いいね削除用質問1",
                              content: "いいね削除用質問本文1",
                              subject: "過去問",
                              user_id: user4.id,
                              book_id: book18.id
                            )

question15 = Question.create!(title: "いいね削除用質問2",
                              content: "いいね削除用質問本文2",
                              subject: "小論文",
                              user_id: user4.id,
                              book_id: book18.id
                            )

question16 = Question.create!(title: "閲覧履歴作成用質問1",
                              content: "閲覧履歴作成用質問本文1",
                              subject: "小論文",
                              user_id: user4.id,
                              book_id: book22.id
                            )

question17 = Question.create!(title: "閲覧履歴作成用質問2",
                              content: "閲覧履歴作成用質問本文2",
                              subject: "小論文",
                              user_id: user.id,
                              book_id: book22.id
                            )

question18 = Question.create!(title: "通知作成用質問1",
                              content: "通知作成用質問本文1",
                              subject: "小論文",
                              user_id: user.id,
                              book_id: book24.id
                            )

question19 = Question.create!(title: "通知作成用質問2",
                              content: "通知作成用質問本文2",
                              subject: "小論文",
                              user_id: user4.id,
                              book_id: book24.id
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

reply6 = Reply.create!(content: "いいね用返信1",
                      user_id: user4.id,
                      question_id: question9.id
                    )

reply7 = Reply.create!(content: "いいね用返信2",
                      user_id: user4.id,
                      question_id: question9.id
                    )

reply8 = Reply.create!(content: "いいね用返信3",
                      user_id: user4.id,
                      question_id: question9.id
                    )

reply9 = Reply.create!(content: "いいね追加用返信1",
                      user_id: user4.id,
                      question_id: question12.id
                    )

reply10 = Reply.create!(content: "いいね追加用返信2",
                      user_id: user4.id,
                      question_id: question12.id
                    )

reply11 = Reply.create!(content: "いいね削除用返信1",
                      user_id: user4.id,
                      question_id: question14.id
                    )

reply12 = Reply.create!(content: "いいね削除用返信2",
                      user_id: user4.id,
                      question_id: question14.id
                    )

reply13 = Reply.create!(content: "閲覧履歴作成用返信1",
                      user_id: user4.id,
                      question_id: question16.id
                    )

reply14 = Reply.create!(content: "閲覧履歴作成用返信2",
                      user_id: user4.id,
                      question_id: question16.id
                    )

reply15 = Reply.create!(content: "通知作成用返信1",
                      user_id: user.id,
                      question_id: question18.id
                    )

reply16 = Reply.create!(content: "通知作成用返信2",
                      user_id: user4.id,
                      question_id: question18.id
                    )

reply17 = Reply.create!(content: "通知作成用返信3",
                      user_id: user.id,
                      question_id: question19.id
                    )

reply18 = Reply.create!(content: "通知作成用返信4",
                      user_id: user4.id,
                      question_id: question19.id
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

subject_question13 = SubjectQuestion.create!(title: "いいね用科目別質問1",
                                            content: "いいね用科目別質問本文1",
                                            subject: "過去問",
                                            user_id: user4.id,
                                          )

subject_question14 = SubjectQuestion.create!(title: "いいね用科目別質問2",
                                            content: "いいね用科目別質問本文2",
                                            subject: "過去問",
                                            user_id: user4.id,
                                          )

subject_question15 = SubjectQuestion.create!(title: "いいね用科目別質問3",
                                            content: "いいね用科目別質問本文3",
                                            subject: "過去問",
                                            user_id: user4.id,
                                          )

subject_question16 = SubjectQuestion.create!(title: "いいね追加用科目別質問1",
                                            content: "いいね追加用科目別質問本文1",
                                            subject: "過去問",
                                            user_id: user4.id,
                                          )

subject_question17 = SubjectQuestion.create!(title: "いいね追加用科目別質問2",
                                            content: "いいね追加用科目別質問本文2",
                                            subject: "過去問",
                                            user_id: user4.id,
                                          )

subject_question18 = SubjectQuestion.create!(title: "いいね削除用科目別質問1",
                                            content: "いいね削除用科目別質問本文1",
                                            subject: "過去問",
                                            user_id: user4.id,
                                          )

subject_question19 = SubjectQuestion.create!(title: "いいね削除用科目別質問2",
                                            content: "いいね削除用科目別質問本文2",
                                            subject: "過去問",
                                            user_id: user4.id,
                                          )

subject_question20 = SubjectQuestion.create!(title: "閲覧履歴作成用科目別質問1",
                                            content: "閲覧履歴作成用科目別質問1",
                                            subject: "小論文",
                                            user_id: user4.id,
                                          )

subject_question21 = SubjectQuestion.create!(title: "閲覧履歴作成用科目別質問2",
                                            content: "閲覧履歴作成用科目別質問2",
                                            subject: "小論文",
                                            user_id: user4.id,
                                          )

subject_question21 = SubjectQuestion.create!(title: "通知作成用科目別質問1",
                                            content: "通知作成用科目別質問1",
                                            subject: "小論文",
                                            user_id: user.id,
                                          )

subject_question22 = SubjectQuestion.create!(title: "通知作成用科目別質問2",
                                            content: "通知作成用科目別質問2",
                                            subject: "小論文",
                                            user_id: user4.id,
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

subject_question_reply6 = SubjectQuestionReply.create!(content: "編集用科目別返信",
                                                      user_id: user.id,
                                                      subject_question_id: subject_question8.id
                                                    )

subject_question_reply7 = SubjectQuestionReply.create!(content: "編集失敗用科目別返信",
                                                      user_id: user.id,
                                                      subject_question_id: subject_question9.id
                                                    )

subject_question_reply8 = SubjectQuestionReply.create!(content: "削除用科目別返信",
                                                      user_id: user.id,
                                                      subject_question_id: subject_question10.id
                                                    )

subject_question_reply9 = SubjectQuestionReply.create!(content: "削除失敗用科目別返信",
                                                      user_id: user.id,
                                                      subject_question_id: subject_question11.id
                                                    )

subject_question_reply10 = SubjectQuestionReply.create!(content: "他ユーザー投稿科目別返信",
                                                      user_id: user2.id,
                                                      subject_question_id: subject_question12.id
                                                    )

subject_question_reply11 = SubjectQuestionReply.create!(content: "いいね用科目別返信1",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question13.id
                                                    )

subject_question_reply12 = SubjectQuestionReply.create!(content: "いいね用科目別返信2",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question14.id
                                                    )

subject_question_reply13 = SubjectQuestionReply.create!(content: "いいね用科目別返信3",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question15.id
                                                    )

subject_question_reply14 = SubjectQuestionReply.create!(content: "いいね追加用科目別返信1",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question16.id
                                                    )

subject_question_reply15 = SubjectQuestionReply.create!(content: "いいね追加用科目別返信2",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question16.id
                                                    )

subject_question_reply16 = SubjectQuestionReply.create!(content: "いいね削除用科目別返信1",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question18.id
                                                    )

subject_question_reply17 = SubjectQuestionReply.create!(content: "いいね削除用科目別返信2",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question18.id
                                                    )

subject_question_reply18 = SubjectQuestionReply.create!(content: "閲覧履歴作成用科目別返信1",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question20.id
                                                    )

subject_question_reply19 = SubjectQuestionReply.create!(content: "閲覧履歴作成用科目別返信2",
                                                      user_id: user4.id,
                                                      subject_question_id: subject_question20.id
                                                    )

subject_question_reply20 = SubjectQuestionReply.create!(content: "通知作成用科目別返信1",
                                                      user_id: user.id,
                                                      subject_question_id: subject_question21.id
                                                    )

subject_question_reply21 = SubjectQuestionReply.create!(content: "通知作成用科目別返信2",
                                                      user_id: user.id,
                                                      subject_question_id: subject_question22.id
                                                    )


survey = Survey.create!(title: "サンプルアンケートタイトル1",
                        content: "サンプルアンケート本文1",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "数学",
                        status: false,
                        user_id: user.id
                      )

survey2 = Survey.create!(title: "サンプルアンケートタイトル2",
                        content: "サンプルアンケート本文2",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "数学",
                        status: false,
                        user_id: user2.id
                      )

survey3 = Survey.create!(title: "サンプルアンケートタイトル3",
                        content: "サンプルアンケート本文3",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "数学",
                        status: false,
                        user_id: user3.id,
                        created_at: Time.now + 10.minute
                      )

survey4 = Survey.create!(title: "サンプルアンケートタイトル4",
                        content: "サンプルアンケート本文4",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "数学",
                        status: false,
                        user_id: user3.id,
                      )

survey5 = Survey.create!(title: "締め切り済みアンケート",
                        content: "締め切り済みアンケート本文",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "数学",
                        status: true,
                        user_id: user3.id,
                      )

survey6 = Survey.create!(title: "進路のアンケート1",
                        content: "進路のアンケート本文1",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "進路・大学",
                        status: false,
                        user_id: user3.id,
                      )

survey7 = Survey.create!(title: "進路のアンケート2",
                        content: "進路のアンケート本文2",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "進路・大学",
                        status: false,
                        user_id: user3.id,
                        created_at: Time.now + 5.minute
                      )

survey8 = Survey.create!(title: "進路のアンケート3",
                        content: "進路のアンケート本文3",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "進路・大学",
                        status: false,
                        user_id: user3.id,
                      )

survey9 = Survey.create!(title: "進路のアンケート4",
                        content: "進路のアンケート本文4",
                        option1: "選択肢1",
                        option2: "選択肢2",
                        option3: "選択肢3",
                        option4: "選択肢4",
                        genre: "進路・大学",
                        status: false,
                        user_id: user3.id,
                      )

survey10 = Survey.create!(title: "締め切り機能用アンケート",
                          content: "締め切り機能用アンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user.id,
                        )

survey11 = Survey.create!(title: "締め切り機能失敗用アンケート",
                          content: "締め切り機能失敗用アンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user.id,
                        )

survey12 = Survey.create!(title: "他ユーザー作成アンケート",
                          content: "他ユーザー作成アンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user2.id,
                        )

survey13 = Survey.create!(title: "削除用アンケート",
                          content: "削除用アンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user.id,
                        )

survey14 = Survey.create!(title: "削除失敗用アンケート",
                          content: "削除失敗用アンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user.id,
                        )

survey15 = Survey.create!(title: "回答作成用アンケート",
                          content: "回答作成用アンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user2.id,
                        )

survey16 = Survey.create!(title: "回答変更用アンケート",
                          content: "回答変更用アンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user2.id,
                        )

survey17 = Survey.create!(title: "回答削除用アンケート",
                          content: "回答削除用アンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user2.id,
                        )

survey18 = Survey.create!(title: "自分が作成したアンケート",
                          content: "自分が作成したアンケート本文",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "その他",
                          status: false,
                          user_id: user.id,
                        )

survey19 = Survey.create!(title: "いいね用アンケート1",
                          content: "いいね用アンケート本文1",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "参考書",
                          status: false,
                          user_id: user4.id,
                        )

survey20 = Survey.create!(title: "いいね用アンケート2",
                          content: "いいね用アンケート本文2",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "参考書",
                          status: false,
                          user_id: user4.id,
                        )

survey21 = Survey.create!(title: "いいね用アンケート3",
                          content: "いいね用アンケート本文3",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "参考書",
                          status: false,
                          user_id: user4.id,
                        )

survey22 = Survey.create!(title: "いいね追加用アンケート1",
                          content: "いいね追加用アンケート本文1",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "参考書",
                          status: false,
                          user_id: user4.id,
                        )

survey23 = Survey.create!(title: "いいね追加用アンケート2",
                          content: "いいね追加用アンケート本文2",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "参考書",
                          status: false,
                          user_id: user4.id,
                        )

survey24 = Survey.create!(title: "いいね削除用アンケート1",
                          content: "いいね削除用アンケート本文1",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "参考書",
                          status: false,
                          user_id: user4.id,
                        )

survey25 = Survey.create!(title: "いいね削除用アンケート2",
                          content: "いいね削除用アンケート本文2",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "参考書",
                          status: false,
                          user_id: user4.id,
                        )

survey26 = Survey.create!(title: "閲覧履歴作成用アンケート1",
                          content: "閲覧履歴作成用アンケート1",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "進路・大学",
                          status: false,
                          user_id: user4.id,
                        )

survey27 = Survey.create!(title: "閲覧履歴作成用アンケート2",
                          content: "閲覧履歴作成用アンケート2",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "進路・大学",
                          status: false,
                          user_id: user4.id,
                        )

survey28 = Survey.create!(title: "通知作成用アンケート1",
                          content: "通知作成用アンケート1",
                          option1: "選択肢1",
                          option2: "選択肢2",
                          option3: "選択肢3",
                          option4: "選択肢4",
                          genre: "進路・大学",
                          status: false,
                          user_id: user.id,
                        )

survey_answer = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user2.id,
                                      survey_id: survey.id
                                    )

survey_answer2 = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user.id,
                                      survey_id: survey4.id
                                    )

survey_answer3 = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user2.id,
                                      survey_id: survey4.id
                                    )

survey_answer4 = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user2.id,
                                      survey_id: survey9.id
                                    )


survey_answer5 = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user.id,
                                      survey_id: survey16.id
                                    )


survey_answer6 = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user3.id,
                                      survey_id: survey16.id
                                    )

survey_answer7 = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user.id,
                                      survey_id: survey17.id
                                    )

survey_answer8 = SurveyAnswer.create!(selected_option: 1,
                                      user_id: user4.id,
                                      survey_id: survey28.id
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

favorite_book5 = FavoriteBook.create!(user_id: user.id,
                                      book_id: book10.id
                                    )

favorite_book5 = FavoriteBook.create!(user_id: user.id,
                                      book_id: book11.id
                                    )

favorite_book5 = FavoriteBook.create!(user_id: user.id,
                                      book_id: book12.id
                                    )

favorite_book6 = FavoriteBook.create!(user_id: user.id,
                                      book_id: book18.id
                                    )

favorite_book7 = FavoriteBook.create!(user_id: user.id,
                                      book_id: book19.id
                                    )

favorite_book8 = FavoriteBook.create!(user_id: user.id,
                                      book_id: book20.id
                                    )

favorite_book9 = FavoriteBook.create!(user_id: user.id,
                                      book_id: book21.id
                                    )

favorite_review = FavoriteReview.create!(user_id: user2.id,
                                          review_id: review.id
                                        )

favorite_review2 = FavoriteReview.create!(user_id: user.id,
                                          review_id: review10.id
                                        )

favorite_review3 = FavoriteReview.create!(user_id: user.id,
                                          review_id: review11.id
                                        )

favorite_review4 = FavoriteReview.create!(user_id: user.id,
                                          review_id: review12.id
                                        )

favorite_review5 = FavoriteReview.create!(user_id: user.id,
                                          review_id: review15.id
                                        )

favorite_review6 = FavoriteReview.create!(user_id: user.id,
                                          review_id: review16.id
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

favorite_question5 = FavoriteQuestion.create!(user_id: user.id,
                                              question_id: question9.id
                                            )

favorite_question6 = FavoriteQuestion.create!(user_id: user.id,
                                              question_id: question10.id
                                            )

favorite_question7 = FavoriteQuestion.create!(user_id: user.id,
                                              question_id: question11.id
                                            )

favorite_question8 = FavoriteQuestion.create!(user_id: user.id,
                                              question_id: question14.id
                                            )

favorite_question9 = FavoriteQuestion.create!(user_id: user.id,
                                              question_id: question15.id
                                            )

favorite_reply = FavoriteReply.create!(user_id: user2.id,
                                        reply_id: reply.id
                                      )

favorite_reply2 = FavoriteReply.create!(user_id: user2.id,
                                        reply_id: reply3.id
                                      )

favorite_reply3 = FavoriteReply.create!(user_id: user.id,
                                        reply_id: reply6.id
                                      )

favorite_reply4 = FavoriteReply.create!(user_id: user.id,
                                        reply_id: reply7.id
                                      )

favorite_reply5 = FavoriteReply.create!(user_id: user.id,
                                        reply_id: reply8.id
                                      )

favorite_reply6 = FavoriteReply.create!(user_id: user.id,
                                        reply_id: reply11.id
                                      )

favorite_reply6 = FavoriteReply.create!(user_id: user.id,
                                        reply_id: reply12.id
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

favorite_subject_question5 = FavoriteSubjectQuestion.create!(user_id: user.id,
                                                            subject_question_id: subject_question13.id
                                                            )

favorite_subject_question6 = FavoriteSubjectQuestion.create!(user_id: user.id,
                                                            subject_question_id: subject_question14.id
                                                            )

favorite_subject_question4 = FavoriteSubjectQuestion.create!(user_id: user.id,
                                                              subject_question_id: subject_question15.id
                                                              )

favorite_subject_question5 = FavoriteSubjectQuestion.create!(user_id: user.id,
                                                              subject_question_id: subject_question18.id
                                                              )

favorite_subject_question6 = FavoriteSubjectQuestion.create!(user_id: user.id,
                                                              subject_question_id: subject_question19.id
                                                              )


favorite_subject_question_reply = FavoriteSubjectQuestionReply.create!(user_id: user2.id,
                                                                        subject_question_reply_id: subject_question_reply.id
                                                                      )

favorite_subject_question_reply2 = FavoriteSubjectQuestionReply.create!(user_id: user.id,
                                                                        subject_question_reply_id: subject_question_reply11.id
                                                                      )

favorite_subject_question_reply3 = FavoriteSubjectQuestionReply.create!(user_id: user.id,
                                                                        subject_question_reply_id: subject_question_reply12.id
                                                                      )

favorite_subject_question_reply4 = FavoriteSubjectQuestionReply.create!(user_id: user.id,
                                                                        subject_question_reply_id: subject_question_reply13.id
                                                                      )

favorite_subject_question_reply5 = FavoriteSubjectQuestionReply.create!(user_id: user.id,
                                                                        subject_question_reply_id: subject_question_reply16.id
                                                                      )

favorite_subject_question_reply6 = FavoriteSubjectQuestionReply.create!(user_id: user.id,
                                                                        subject_question_reply_id: subject_question_reply17.id
                                                                      )


favorite_survey = FavoriteSurvey.create!(user_id: user2.id,
                                          survey_id: survey.id
                                        )

favorite_survey2 = FavoriteSurvey.create!(user_id: user.id,
                                          survey_id: survey2.id
                                        )

favorite_survey3 = FavoriteSurvey.create!(user_id: user3.id,
                                          survey_id: survey2.id
                                        )

favorite_survey4 = FavoriteSurvey.create!(user_id: user4.id,
                                          survey_id: survey2.id
                                        )

favorite_survey5 = FavoriteSurvey.create!(user_id: user2.id,
                                          survey_id: survey8.id
                                        )

favorite_survey6 = FavoriteSurvey.create!(user_id: user.id,
                                          survey_id: survey19.id
                                        )

favorite_survey7 = FavoriteSurvey.create!(user_id: user.id,
                                          survey_id: survey20.id
                                        )

favorite_survey8 = FavoriteSurvey.create!(user_id: user.id,
                                          survey_id: survey21.id
                                        )

favorite_survey9 = FavoriteSurvey.create!(user_id: user.id,
                                          survey_id: survey24.id
                                        )

favorite_survey10 = FavoriteSurvey.create!(user_id: user.id,
                                          survey_id: survey25.id
                                        )

10.times do |i|
  BrowsingHistory.create!(book_id: i + 1, user_id: user.id)
end

10.times do |i|
  BrowsingHistory.create!(review_id: i + 1, user_id: user.id)
end

10.times do |i|
  BrowsingHistory.create!(question_id: i + 1, user_id: user.id)
end

10.times do |i|
  BrowsingHistory.create!(reply_id: i + 1, user_id: user.id)
end

10.times do |i|
  BrowsingHistory.create!(subject_question_id: i + 1, user_id: user.id)
end

10.times do |i|
  BrowsingHistory.create!(subject_question_reply_id: i + 1, user_id: user.id)
end

10.times do |i|
  BrowsingHistory.create!(survey_id: i + 1, user_id: user.id)
end

notification = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    review_id: review19.id,
                                    action_type: "Favorite",
                                    action_to: "Review",
                                    is_checked: false
                                  )

notification2 = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    question_id: question18.id,
                                    action_type: "Favorite",
                                    action_to: "Question",
                                    is_checked: false
                                  )

notification3 = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    reply_id: reply15.id,
                                    action_type: "Favorite",
                                    action_to: "Reply",
                                    is_checked: false
                                  )

notification4 = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    subject_question_id: subject_question21.id,
                                    action_type: "Favorite",
                                    action_to: "SubjectQuestion",
                                    is_checked: false
                                  )

notification5 = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    subject_question_reply_id: subject_question_reply20.id,
                                    action_type: "Favorite",
                                    action_to: "SubjectQuestionReply",
                                    is_checked: false
                                  )

notification6 = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    survey_id: survey28.id,
                                    action_type: "Favorite",
                                    action_to: "Survey",
                                    is_checked: false
                                  )

notification7 = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    question_id: question18.id,
                                    reply_id: reply16.id,
                                    action_type: "Reply",
                                    action_to: "Reply",
                                    is_checked: false
                                  )

notification8 = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    question_id: question19.id,
                                    reply_id: reply18.id,
                                    action_type: "Reply",
                                    action_to: "Reply",
                                    is_checked: false
                                  )

notification9 = Notification.create!(action_user_id: user4.id,
                                    target_user_id: user.id,
                                    survey_id: survey28.id,
                                    action_type: "SurveyAnswer",
                                    action_to: "SurveyAnswer",
                                    is_checked: false
                                  )



