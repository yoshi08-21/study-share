import axios from "@/plugins/axios"

export default async function({ route, redirect }) {
  const { name, params } = route

  // ユーザーへのバリデーション
  if(name === "users-id") {
    const userId = params.id

    try {
      const response = await axios.get("/users/check_existence", {
        params: {
          id: userId
        }
      })
      if(response.status === 200) {
        return
      }
    } catch(error) {
      return redirect({
        path: "/",
        query: { message: "存在しないユーザーです" }
      })
    }
  }


  // 参考書へのバリデーション
  if(name === "books-id") {
    const bookId = params.id

    try {
      const response = await axios.get("/books/check_existence", {
        params: {
          id: bookId
        }
      })
      if(response.status === 200) {
        return
      }
    } catch(error) {
      return redirect({
        path: "/",
        query: { message: "存在しない参考書です" }
      })
    }
  }

  // レビューへのバリデーション
  if(name === "books-book_id-reviews-id") {
    const bookId = params.book_id
    const reviewId = params.id

    try {
      const response = await axios.get("/reviews/check_existence", {
        params: {
          book_id: bookId,
          id: reviewId
        }
      })
      if(response.status === 200) {
        return
      }
    } catch(error) {
      return redirect({
        path: "/",
        query: { message: "存在しないレビューです" }
      })
    }
  }

  // 質問へのバリデーション
  if(name === "books-book_id-questions-id") {
    const bookId = params.book_id
    const questionId = params.id

    try {
      const response = await axios.get("/questions/check_existence", {
        params: {
          book_id: bookId,
          id: questionId
        }
      })
      if(response.status === 200) {
        return
      }
    } catch(error) {
      return redirect({
        path: "/",
        query: { message: "存在しない質問です" }
      })
    }
  }

  // 返信へのバリデーション

  if(name === "books-book_id-questions-question_id-replies-id") {
    const bookId = params.book_id
    const questionId = params.question_id
    const replyId = params.id

    try {
      const response = await axios.get("/replies/check_existence", {
        params: {
          book_id: bookId,
          question_id: questionId,
          id: replyId
        }
      })
      if(response.status === 200) {
        return
      }
    } catch(error) {
      return redirect({
        path: "/",
        query: { message: "存在しない返信です" }
      })
    }
  }

  // 科目別質問へのバリデーション
  if(name === "subjectQuestions-id") {
    const subjectQuestionId = params.id

    try {
      const response = await axios.get("/subject_questions/check_existence", {
        params: {
          id: subjectQuestionId
        }
      })
      if(response.status === 200) {
        return
      }
    } catch(error) {
      return redirect({
        path: "/",
        query: { message: "存在しない質問です" }
      })
    }
  }



  // 科目別質問への返信へのバリデーション
  if(name === "subjectQuestions-subjectQuestion_id-subjectQuestionReplies-id") {
    const subjectQuestionId = params.subjectQuestion_id
    const subjectQuestionReplyId = params.id

    try {
      const response = await axios.get("/subject_question_replies/check_existence", {
        params: {
          subject_question_id: subjectQuestionId,
          id: subjectQuestionReplyId
        }
      })
      if(response.status === 200) {
        return
      }
    } catch(error) {
      return redirect({
        path: "/",
        query: { message: "存在しない返信です" }
      })
    }
  }






}

