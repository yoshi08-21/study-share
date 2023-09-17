export default {
  data() {
    return {
      dialog: false,
      reviewDialog: false,
      questionDialog: false,
      selectSubjectDialog: false,
      confirmationDialog: false,
      showDeleteConfirmation: false,
      editBookDialog: false,
      replyDialog: false,
      subjectQuestionReplyDialog: false,

    }
  },
  methods: {
    openReviewDialog() {
      if(this.currentUser) {
        this.reviewDialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    openQuestionDialog() {
      if(this.currentUser) {
        this.questionDialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    openReplyDialog() {
      if(this.currentUser) {
        this.replyDialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    openSubjectQuestionReplyDialog() {
      if(this.currentUser) {
        this.subjectQuestionReplyDialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },

  }
}
