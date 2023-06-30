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

    <br>
    <!-- 自分のレビューもしくは未ログイン時はいいねの件数だけ表示 -->
    <template v-if="this.currentUser && this.replyUser.id !== this.currentUser.id">
      <template v-if="!isFavorite">
        <v-btn @click="addToFavorite">いいね！する</v-btn>
        <P>いいね！（{{ this.favoriteRepliesCount }}件）</P>
      </template>
      <template v-else>
        <v-btn @click="removeFromFavorite">いいね！を削除する</v-btn>
        <P>いいね！（{{ this.favoriteRepliesCount }}件）</P>
      </template>
    </template>
    <template v-else>
      <P>いいね！（{{ this.favoriteRepliesCount }}件）</P>
    </template>


    <!-- 自分の返信のみ編集・削除ボタンを表示 -->
    <br>
    <template v-if="this.currentUser && this.replyUser.id == this.currentUser.id">
      <v-btn @click="dialog=true">編集する</v-btn>
      <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    </template>

    <br>
    <v-btn @click="previousReply">前の返信</v-btn>
    <v-btn @click="nextReply">次の返信</v-btn>


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
  async asyncData({ params, store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [replyResponse, repliesResponse] = await Promise.all([
        axios.get(`/books/${params.book_id}/questions/${params.question_id}/replies/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get(`/books/${params.book_id}/questions/${params.question_id}/replies`)
      ])

      console.log(replyResponse.data)
      console.log(repliesResponse.data)
      return {
        book: replyResponse.data.book,
        question: replyResponse.data.question,
        questionUser: replyResponse.data.question.user,
        reply: replyResponse.data.reply,
        replyUser: replyResponse.data.reply.user,
        favoriteRepliesCount: replyResponse.data.favorite_replies_count,
        replies: repliesResponse.data,
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
  async created() {
    try {
      let currentUserId = ""
      const currentUser = this.$store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const response = await axios.get("replies/is_favorite", {
        params: {
          user_id: currentUserId,
          reply_id: this.$route.params.id
        }
      })
      console.log(response)
      this.isFavorite = response.data.is_favorite
      this.favoriteReplyId = response.data.favorite_reply_id
    } catch(error) {
      console.log("エラー文です")
      console.log(error)
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
    async addToFavorite() {
      try {
        const response = await axios.post(`/replies/${this.reply.id}/favorite_replies`, {
          user_id: this.currentUser.id
        })
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！しました"
        this.isFavorite = true
        this.favoriteReplyId = response.data.id
        this.favoriteRepliesCount += 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね！されています"
      }
    },
    async removeFromFavorite() {
      try {
        const response = await axios.delete(`/replies/${this.reply.id}/favorite_replies/${this.favoriteReplyId}`, {
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
        this.favoriteRepliesCount -= 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね！されていません"
      }
    },
    nextReply() {
      const index = this.replies.findIndex(item => item.id === this.reply.id)
      const nextIndex = index + 1
      const nextReply = this.replies[nextIndex]
      const lastItem = this.replies[this.replies.length - 1]
      if(this.reply.id !== lastItem.id) {
        this.$router.push({ path: `/books/${this.question.book_id}/questions/${this.reply.question_id}/replies/${nextReply.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最後の返信です"
      }
    },
    previousReply() {
      const index = this.replies.findIndex(item => item.id === this.reply.id)
      const previousIndex = index - 1
      const previousReply = this.replies[previousIndex]
      const firstItem = this.replies[0]
      if(this.reply.id !== firstItem.id) {
        this.$router.push({ path: `/books/${this.question.book_id}/questions/${this.reply.question_id}/replies/${previousReply.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最初の返信です"
      }
    }

  }
}
</script>

<style>

</style>
