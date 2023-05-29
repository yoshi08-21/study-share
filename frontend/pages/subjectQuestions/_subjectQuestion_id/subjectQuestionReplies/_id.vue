<template>
  <div>
    <h2>科目別質問への返信：詳細ページ</h2>
    <h3>返信id: {{ this.subjectQuestionReply.id }}</h3>

    <h4>質問情報</h4>
    <p>タイトル:{{ this.subjectQuestion.title }}</p>
    <p>本文:{{ this.subjectQuestion.content }}</p>
    <h3>questioned by<span class="link-text" @click="redirectToUser(subjectQuestionUser)"> {{ this.subjectQuestionUser.name }} </span></h3>

    <br><br><hr>
    <h3>返信</h3>
    <p>本文:{{ this.subjectQuestionReply.content }}</p>
    <h3>replied by<span class="link-text" @click="redirectToUser(subjectQuestionReplyUser)"> {{ this.subjectQuestionReplyUser.name }} </span></h3>


    <br>
    <!-- 自分のレビューもしくは未ログイン時はいいねの件数だけ表示 -->
    <template v-if="this.currentUser && this.subjectQuestionReplyUser.id !== this.currentUser.id">
      <template v-if="!isFavorite">
        <v-btn @click="addToFavorite">いいね！する</v-btn>
        <P>いいね！（{{ this.favoriteSubjectQuestionRepliesCount }}件）</P>
      </template>
      <template v-else>
        <v-btn @click="removeFromFavorite">いいね！を削除する</v-btn>
        <P>いいね！（{{ this.favoriteSubjectQuestionRepliesCount }}件）</P>
      </template>
    </template>
    <template v-else>
      <P>いいね！（{{ this.favoriteSubjectQuestionRepliesCount }}件）</P>
    </template>

    <!-- 自分の返信のみ編集・削除ボタンを表示 -->
    <br>
    <template v-if="this.currentUser && this.subjectQuestionReplyUser.id == this.currentUser.id">
      <v-btn @click="dialog=true">編集する</v-btn>
      <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    </template>

    <!-- 返信編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          返信を編集する
        </v-card-title>
        <v-card-text>
          <edit-reply
            :content="subjectQuestionReply.content"
            @submitReply="editSubjectQuestionReply"
            @closeDialog="dialog = false"
          ></edit-reply>
        </v-card-text>
      </v-card>
    </v-dialog>

    <!-- 質問削除の確認ダイアログ -->
    <v-dialog v-model="showDeleteConfirmation">
      <v-card>
        <v-card-title>
          削除した返信は復元できません！
        </v-card-title>
        <v-card-text>
          <strong>
            返信を削除しますか？
          </strong>
        </v-card-text>
        <v-card-actions class="justify-content-center">
          <v-btn @click="deleteSubjectQuestionReply">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>



    <br><br>
    <v-btn @click="redirectToSubjectQuestion">質問詳細に戻る</v-btn>


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditReply from '../../../../components/replies/EditReply.vue'
import axios from "@/plugins/axios"


export default {
  components: { EditReply },
  async asyncData({ params, store }) {
    try {
      const responce = await axios.get(`/subject_questions/${params.subjectQuestion_id}/subject_question_replies/${params.id}`, {
        params: {
          current_user_id: store.getters["auth/getCurrentUser"].id
        }
      })
      console.log(responce.data)
      return {
        subjectQuestion: responce.data.subject_question,
        subjectQuestionUser: responce.data.subject_question.user,
        subjectQuestionReply: responce.data.subject_question_reply,
        subjectQuestionReplyUser: responce.data.subject_question_reply.user,
        favoriteSubjectQuestionRepliesCount: responce.data.favorite_subject_question_replies_count,
        params
      };
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      dialog: false,
      showDeleteConfirmation: false,
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
      isFavorite: false,
      favoriteSubjectQuestionReplyId: "",
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
  async created() {
    try {
      const response = await axios.get("subject_question_replies/is_favorite", {
        params: {
          user_id: this.$store.getters["auth/getCurrentUserId"],
          subject_question_reply_id: this.$route.params.id
        }
      })
      console.log(response)
      this.isFavorite = response.data.is_favorite
      this.favoriteSubjectQuestionReplyId = response.data.favorite_reply_id
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  mounted() {
    if (this.$route.query.message) {
      this.snackbarColor = "primary"
      this.snackbar = true
      this.flashMessage = this.$route.query.message
      // this.$snackbar.show(this.$route.query.message)
    }
  },
  methods: {
    redirectToUser(user) {
      console.log("currentUser:" + this.currentUser.id)
      console.log("user:" + user.id)
      if(this.currentUser.id !== user.id ) {
        this.$router.push({ path: `/users/${user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
      }
    },
    redirectToSubjectQuestion() {
      this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}` })
    },
    async editSubjectQuestionReply(data) {
      try {
        const response = await axios.patch(`/subject_questions/${this.subjectQuestion.id}/subject_question_replies/${this.subjectQuestionReply.id}`, {
          content: data.content,
          current_user_id: this.currentUser.id
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "返信の編集が完了しました"
        this.subjectQuestionReply.content = response.data.content
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を編集できませんでした"
      }
      this.dialog = false
    },
    async deleteSubjectQuestionReply() {
      try {
        const response = await axios.delete(`/subject_questions/${this.subjectQuestion.id}/subject_question_replies/${this.subjectQuestionReply.id}`, {
          params: { current_user_id: this.currentUser.id }
        })
        console.log(response)
        this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}`, query: { message: '返信を削除しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を削除できませんでした"
        this.dialog = false
      }
    },
    async addToFavorite() {
      try {
        const response = await axios.post(`/subject_question_replies/${this.subjectQuestionReply.id}/favorite_subject_question_replies`, {
          user_id: this.currentUser.id
        })
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！しました"
        this.isFavorite = true
        this.favoriteSubjectQuestionReplyId = response.data.id
        this.favoriteSubjectQuestionRepliesCount += 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね！されています"
      }
    },
    async removeFromFavorite() {
      try {
        const response = await axios.delete(`/subject_question_replies/${this.subjectQuestionReply.id}/favorite_subject_question_replies/${this.favoriteSubjectQuestionReplyId}`, {
          params: {
            user_id: this.currentUser.id
          }
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteReplyId = null
        this.favoriteSubjectQuestionRepliesCount -= 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね！されていません"
      }
    },

  }
}
</script>

<style>

</style>
