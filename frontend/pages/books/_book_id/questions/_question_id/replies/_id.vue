<template>
  <div>
    <h2>返信詳細</h2>
    <h3>返信id: {{ this.reply.id }}</h3>

    <h4>質問情報</h4>
    <p>タイトル:{{ this.question.title }}</p>
    <p>本文:{{ this.question.content }}</p>
    <h3>to: <span class="link-text" @click="redirectToBook">{{ this.book.name }}</span></h3>
    <h3>questioned by<span class="link-text" @click="redirectToUser(questionUser)"> {{ this.questionUser.name }} </span></h3>

    <br><br><hr>
    <h3>返信</h3>
    <p>本文:{{ this.reply.content }}</p>
    <h3>replied by<span class="link-text" @click="redirectToUser(replyUser)"> {{ this.replyUser.name }} </span></h3>

    <!-- 自分の返信のみ編集・削除ボタンを表示 -->
    <br>
    <template v-if="this.currentUser && this.replyUser.id == this.currentUser.id">
      <v-btn @click="dialog=true">編集する</v-btn>
      <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    </template>

    <br><br>
    <v-btn @click="redirectToQuestion">質問詳細に戻る</v-btn>

    <!-- 返信編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          返信を編集する
        </v-card-title>
        <v-card-text>
          <edit-reply
            :content="reply.content"
            @submitReply="editReply"
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
          <v-btn @click="deleteReply">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditReply from '../../../../../../components/replies/EditReply.vue'
import axios from "@/plugins/axios"


export default {
  components: { EditReply },
  async asyncData({ params }) {
    try {
      const responce = await axios.get(`/books/${params.book_id}/questions/${params.question_id}/replies/${params.id}`)
      console.log(responce.data)
      return {
        book: responce.data.book,
        question: responce.data.question,
        questionUser: responce.data.question.user,
        reply: responce.data.reply,
        replyUser: responce.data.reply.user,
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
      favoriteReplyId: "",
    }
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
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
    redirectToQuestion() {
      this.$router.push({ path: `/books/${this.book.id}/questions/${this.question.id}` })
    },
    redirectToBook() {
      this.$router.push({ path: `/books/${this.book.id}` })
    },
    async editReply(data) {
      try {
        const response = await axios.patch(`/books/${this.book.id}/questions/${this.question.id}/replies/${this.reply.id}`, {
          content: data.content,
          current_user_id: this.currentUser.id
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "返信の編集が完了しました"
        this.reply.content = response.data.content
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を編集できませんでした"
      }
      this.dialog = false
    },
    async deleteReply() {
      try {
        const response = await axios.delete(`/books/${this.book.id}/questions/${this.question.id}/replies/${this.reply.id}`, {
          params: { current_user_id: this.currentUser.id }
        })
        console.log(response)
        this.$router.push({ path: `/books/${this.book.id}/questions/${this.question.id}`, query: { message: '返信を削除しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を削除できませんでした"
        this.dialog = false
      }
    },

  }
}
</script>

<style>

</style>
