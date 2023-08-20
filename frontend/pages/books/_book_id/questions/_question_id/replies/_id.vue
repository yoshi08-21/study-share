<template>
  <div>
    <div style="margin-bottom: 10px;">
      <h3>質問情報</h3>
    </div>
    <v-card
      elevation="8"
    >
      <v-row>
        <v-col cols="2" class="mt-8">
          <div @click="goToUser(questionUser)" style="cursor: pointer;">
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
              <v-avatar size="100">
                <v-img :src="questionUser.image" alt="画像" contain></v-img>
              </v-avatar>
            </v-col>
          </v-row>
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
                <span style="text-decoration: underline;">{{ $truncate(questionUser.name, 10) }}</span>
              </v-col>
            </v-row>
          </div>
        </v-col>
        <v-col cols="7">

          <v-card-title>
            <nuxt-link :to="`/books/${question.book_id}/questions/${question.id}`">{{ question.title }}</nuxt-link>
          </v-card-title>

          <v-card-text>
            <v-textarea
              :value="question.content"
              readonly
              filled
              rounded
              dense
              no-resize
              rows="4"
              style="height: 150px;"
            >
            </v-textarea>
          </v-card-text>

          <v-card-actions>
            <v-row class="d-flex align-center justify-center">
              <v-col cols="4">
                <v-icon>mdi-comment-text-outline</v-icon>
                返信: {{ question.replies_count }}件
              </v-col>
              <v-col cols="4">
                <v-icon>mdi-heart-multiple</v-icon>
                いいね! ({{ question.favorite_questions_count }})
              </v-col>
            </v-row>
            <p>
            </p>
          </v-card-actions>

        </v-col>
        <v-col cols="3" class="mt-3">
          <div style="height: 250px;">
            <v-row style="flex-direction: column; height: 150px; width: 220px;">
              <v-col class="d-flex justify-center align-center">
                <v-img
                  :src="book.image"
                  alt="画像"
                  contain
                  height="150"
                  width="220"
                >
                </v-img>
              </v-col>
            </v-row>
            <v-row>
              <v-col class="d-flex justify-center align-center mt-2">
                <nuxt-link :to="`/books/${question.book_id}}`">{{ $truncate(book.name, 25) }}</nuxt-link>
              </v-col>
            </v-row>
          </div>
        </v-col>
      </v-row>
    </v-card>


    <br><br><br>
    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>返信詳細</h2>
      <nuxt-link :to="`/books/${question.book_id}/questions/${question.id}`">質問詳細に戻る</nuxt-link>
    </div>
    <v-card
      elevation="8"
      style="padding-bottom: 1px;"
    >
      <v-row>
        <v-col cols="2" class="mt-8">
          <div @click="goToUser(replyUser)" style="cursor: pointer;">
            <v-row>
              <v-col class="d-flex justify-center align-center text-center">
                <v-avatar size="100">
                  <v-img :src="replyUser.image" alt="画像" contain></v-img>
                </v-avatar>
              </v-col>
            </v-row>
            <v-row>
              <v-col class="d-flex justify-center align-center text-center">
                  <span style="text-decoration: underline;">{{ $truncate(replyUser.name, 10) }}</span>
              </v-col>
            </v-row>
          </div>
        </v-col>
        <v-col cols="8" class="mt-n2">

          <v-card-title>
            <v-textarea
              :value="reply.content"
              readonly
              outlined
              rounded
              dense
              auto-grow
            >
            </v-textarea>
          </v-card-title>

          <template v-if="reply.image">
            <v-row>
              <v-col class="d-flex justify-center">
                <v-img
                  @click="showFullImage = true"
                  :src="reply.image"
                  alt="画像"
                  contain
                  max-height="250"
                  max-width="250"
                  style="cursor: pointer;"
                ></v-img>
              </v-col>
            </v-row>
            <v-row>
              <v-col class="d-flex justify-center">
                *画像をクリックすると拡大できます
              </v-col>
            </v-row>
          </template>

          <br>
          <v-card-actions>
            <v-row class="d-flex align-center justify-center">
              <v-col cols="4">
                <favorite-button
                  :currentUser="currentUser"
                  :user="replyUser"
                  :isFavorite="isFavorite"
                  :favoriteCount="reply.favorite_replies_count"
                  @addToFavorite="addToFavorite"
                  @removeFromFavorite="removeFromFavorite"
                ></favorite-button>
              </v-col>
              <v-col cols="4">
                <v-icon>mdi-calendar-clock</v-icon>
                {{ reply.created_at }}
              </v-col>
            </v-row>
          </v-card-actions>

        </v-col>
        <v-col cols="2" class="d-flex flex-column" style="padding: 20px;">
          <template v-if="currentUser && replyUser.id == currentUser.id">
            <v-btn @click="dialog=true" style="margin-bottom: 10px;">編集する</v-btn>
            <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
          </template>
        </v-col>
      </v-row>
    </v-card>

    <br><br>
    <content-navigator
      :content="'返信'"
      @previousContent="previousReply"
      @nextContent="nextReply"
    >
    </content-navigator>


    <!-- 返信編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title style="justify-content: center;">
          <h2>返信を編集する</h2>
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

    <!-- 大きいサイズの画像表示用のダイアログ -->
    <v-dialog v-model="showFullImage">
      <v-card
        max-height="800px"
        style="padding: 10px;"
      >
        <v-row>
          <v-col cols="6" class="d-flex justify-start">
            <v-card-title>拡大画像</v-card-title>
          </v-col>
          <v-col cols="6" class="d-flex justify-end align-center">
            <v-btn @click="showFullImage = false">閉じる</v-btn>
          </v-col>
        </v-row>
        <hr>
        <v-row style="margin-top: 10px; margin-bottom: 5px;">
          <v-col class="d-flex justify-center">
            <v-img
              :src="reply.image"
              max-height="500"
              max-width="500"
              contain
            ></v-img>
          </v-col>
        </v-row>
        <v-row>
          <v-col class="d-flex justify-center">
            <v-btn @click="showFullImage = false">閉じる</v-btn>
          </v-col>
        </v-row>
      </v-card>
    </v-dialog>


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditReply from '../../../../../../components/replies/EditReply.vue'
import ContentNavigator from '../../../../../../components/global/ContentNavigator.vue'
import axios from "@/plugins/axios"


export default {
  components: { EditReply, ContentNavigator },
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
        questionUser: replyResponse.data.question_user,
        reply: replyResponse.data.reply,
        replyUser: replyResponse.data.reply_user,
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
      showFullImage: false,

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
    goToUser(user) {
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
      const formData = new FormData()

      formData.append("reply[user_id]", this.currentUser.id);
      formData.append("reply[content]", data.content);
      if (data.image) {
          formData.append("reply[image]", data.image);
      }

      try {
        const response = await axios.patch(`/books/${this.book.id}/questions/${this.question.id}/replies/${this.reply.id}`, formData)
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "返信の編集が完了しました"
        this.reply.content = response.data.reply.content
        if (response.data.image_url) {
          this.reply.image = response.data.image_url
        }
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
        this.reply.favorite_replies_count +=1
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
        this.reply.favorite_replies_count -=1
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
