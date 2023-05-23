<template>
  <div>
    <h2>質問詳細</h2>
    <h3>質問id: {{ this.question.id }}</h3>

    <h4>参考書情報</h4>
    <p>タイトル:{{  this.book.name }}</p>

    <h3>質問</h3>
    <h4>タイトル:{{ this.question.title }}</h4>
    <p>本文:{{ this.question.content }}</p>
    <h3>questioned by<span class="link-text" @click="redirectToUser"> {{ this.user.name }} </span></h3>

    <!-- 自分の質問のみ編集・削除ボタンを表示 -->
    <br>
    <template v-if="this.currentUser && this.user.id == this.currentUser.id">
      <v-btn @click="dialog=true">編集する</v-btn>
      <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    </template>

    <br><br>
    <v-btn @click="redirectToBook">参考書に戻る</v-btn>

    <!-- 質問編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          質問を編集する
        </v-card-title>
        <v-card-text>
          <edit-question
            :title="question.title"
            :content="question.content"
            @submitQuestion="editQuestion"
            @closeDialog="dialog = false"
          ></edit-question>
        </v-card-text>
      </v-card>
    </v-dialog>

        <!-- 質問削除の確認ダイアログ -->
        <v-dialog v-model="showDeleteConfirmation">
      <v-card>
        <v-card-title>
          削除した質問は復元できません！
        </v-card-title>
        <v-card-text>
          <strong>
            質問を削除しますか？
          </strong>
        </v-card-text>
        <v-card-actions class="justify-content-center">
          <v-btn @click="deleteQuestion">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditQuestion from '../../../../components/questions/EditQuestion.vue'
import axios from "@/plugins/axios"

export default {
  components: { EditQuestion },
  async asyncData({ params }) {
    const responce = await axios.get(`/books/${params.book_id}/questions/${params.id}`)
    console.log(responce.data.question)
    console.log(responce.data.book)
    console.log(responce.data.question.user)
    return {
      book: responce.data.book,
      question: responce.data.question,
      user: responce.data.question.user,
      params
    };
  },
  data() {
    return {
      dialog: false,
      showDeleteConfirmation: false,
      snackbar: false,
      snackbarColor: "primary",
      flashMessage: "テストメッセージ",
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
    redirectToBook() {
      this.$router.push({ path: `/books/${this.book.id}` })
    },
    redirectToUser() {
      console.log("currentUser:" + this.currentUser.id)
      console.log("user:" + this.user.id)
      if(this.currentUser.id !== this.user.id ) {
        this.$router.push({ path: `/users/${this.user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
      }
    },
    async editQuestion(data) {
      try {
        const response = await axios.patch(`/books/${this.params.book_id}/questions/${this.question.id}`, {
          title: data.title,
          content: data.content,
          current_user_id: this.currentUser.id
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "質問の編集が完了しました"
        this.question.title = response.data.title
        this.question.content = response.data.content

      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を編集できませんでした"
      }
      this.dialog = false
    },
    async deleteQuestion() {
      try {
        const response = await axios.delete(`/books/${this.params.book_id}/questions/${this.question.id}`, {
          params: { current_user_id: this.currentUser.id }
        })
        console.log(response)
        this.$router.push({ path: `/books/${this.book.id}`, query: { message: '質問を削除しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を削除できませんでした"
        this.dialog = false
      }
    },
  }


}
</script>

<style>

</style>