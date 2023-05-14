<template>
  <div>
    <h2>レビュー詳細</h2>
    <h3>レビューid:{{ this.$route.params.id }}</h3>

    <h4>参考書情報</h4>
    <p>タイトル:{{ book.name }}</p>

    <h3>レビュー</h3>
    <h4>評価:{{ review.rating }}</h4>
    <h4>タイトル:{{ review.title }}</h4>
    <p>本文:{{ review.content }}</p>
    <p>reviewd by {{ user.name }}</p>

    <br>
    <v-btn @click="dialog=true">編集する</v-btn>
    <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
    <br><br>
    <v-btn @click="redirectToBook">参考書に戻る</v-btn>

    <!-- レビュー編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          レビューを編集する
        </v-card-title>
        <v-card-text>
          <edit-review
            :rating="review.rating"
            :title="review.title"
            :content="review.content"
            @submitReview="editReview"
            @closeDialog="dialog = false"
          ></edit-review>
        </v-card-text>
      </v-card>
    </v-dialog>

    <!-- レビュー削除の確認ダイアログ -->
    <v-dialog v-model="showDeleteConfirmation">
      <v-card>
        <v-card-title>
          削除したレビューは復元できません！
        </v-card-title>
        <v-card-text>
          <strong>
            レビューを削除しますか？
          </strong>
        </v-card-text>
        <v-card-actions class="justify-content-center">
          <v-btn @click="deleteReview">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>


    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
    <!-- <show-snackbar ref="snackbar" /> -->
  </div>
</template>

<script>

import EditReview from '../../../../components/reviews/EditReview.vue'
import axios from "@/plugins/axios"

export default {

  components: {
    EditReview
  },
  async asyncData({ params }) {
    const responce = await axios.get(`/books/${params.book_id}/reviews/${params.id}`)
    console.log(responce.data.review)
    console.log(responce.data.book)
    console.log(responce.data.review.user)
    return {
      book: responce.data.book,
      review: responce.data.review,
      user: responce.data.review.user,
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
  mounted() {
    if (this.$route.query.message) {
      this.snackbarColor = "primary"
      this.snackbar = true
      this.flashMessage = this.$route.query.message
      // this.$snackbar.show(this.$route.query.message)
    }
  },
  methods: {
    async editReview(data) {
      try {
        const response = await axios.patch(`/books/${this.params.book_id}/reviews/${this.params.id}`, {
          title: data.title,
          content: data.content,
          rating: data.rating
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "レビューの編集が完了しました"
        // this.$snackbar.showSnackbar("Hello, Snackbar!", "success");
        // this.$refs.snackbar.showSnackbar('This is a message', 'success')
        this.review.title = response.data.title
        this.review.content = response.data.content
        this.review.rating = response.data.rating
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "レビューを編集できませんでした"
      }
      this.dialog = false
    },
    async deleteReview() {
      try {
        const response = await axios.delete(`/books/${this.params.book_id}/reviews/${this.params.id}`)
        console.log(response)
        this.$router.push({ path: `/books/${this.book.id}`, query: { message: 'レビューを削除しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "レビューを削除できませんでした"
      }
    },
    redirectToBook() {
      this.$router.push({ path: `/books/${this.book.id}` })
    }
  }
}
</script>

<style>

</style>
