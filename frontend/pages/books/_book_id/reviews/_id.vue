<template>
  <div>
    <div style="margin-bottom: 10px;">
      <h3>参考書情報</h3>
    </div>
    <v-card
      height="300"
    >
      <v-row>
        <v-col cols="3" class="d-flex justify-center">
          <div v-if="book.image">
              <v-img
                :src="book.image"
                alt="画像"
                contain
                haight="180"
                width="160"
              ></v-img>
            </div>
        </v-col>
        <v-col cols="7">
          <v-card-title>
            <h3> {{ book.name }}</h3>

          </v-card-title>
          <v-card-subtitle style="margin-top: -20px;">
            <v-row class="d-flex align-center">
              <v-col cols="4">
                <v-rating
                  v-model="book.average_rating"
                  :readonly="true"
                  background-color="orange lighten-3"
                  color="orange"
                  dense
                  large
                >
                </v-rating>
              </v-col>
              <v-col cols="3">
                <h2>
                  ({{ book.average_rating }})
                </h2>
              </v-col>
            </v-row>
          </v-card-subtitle>

          <v-card-content>
            <h3 style="margin-bottom: 5px;">科目: {{ book.subject }}</h3>
            <h4>作者: {{ book.author }}</h4>
            <h4>出版社: {{ book.publisher }}</h4>
          </v-card-content>
          <br><br>
          <v-card-actions>
            <v-row class="d-flex align-center">
              <v-col cols="3">
                <v-icon>mdi-comment-text-outline</v-icon>
                レビュー: {{ book.reviews_count }}件
              </v-col>
              <v-col cols="3">
                <v-icon>mdi-comment-question-outline</v-icon>
                質問: {{ book.reviews_count }}件
              </v-col>
              <v-col cols="3">
                <v-icon>mdi-heart-multiple</v-icon>
                お気に入り ({{ book.favorite_books_count }})
              </v-col>
            </v-row>
          </v-card-actions>
        </v-col>
      </v-row>
    </v-card>


    <br><br><br>


    <hr>

    <br><br><br>
    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>レビュー詳細</h2>
      <nuxt-link :to="`/books/${book.id}`">参考書詳細に戻る</nuxt-link>
    </div>
    <v-card
      elevation="8"
      min-height="400"
      style="padding-bottom: 1px;"
    >
      <v-row>
        <v-col cols="2" class="mt-8">
          <div @click="goToUser(user)" style="cursor: pointer;">
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
              <v-avatar size="100">
                <v-img :src="user.image" alt="画像" contain></v-img>
              </v-avatar>
            </v-col>
          </v-row>
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
                <span style="text-decoration: underline;">{{ $truncate(user.name, 10) }}</span>
              </v-col>
            </v-row>
          </div>
        </v-col>
        <v-col cols="8" class="mt-n2">
          <v-card-title>
            <v-row class="d-flex align-center" style="margin-top: 10px;">
              <v-col cols="4">
                <v-rating
                  v-model="review.rating"
                  :readonly="true"
                  background-color="orange lighten-3"
                  color="orange"
                  dense
                  large
                >
                </v-rating>
              </v-col>
              <v-col cols="2">
                <h3>
                  ({{ review.rating }})
                </h3>
              </v-col>
            </v-row>
          </v-card-title>
          <v-card-subtitle style="margin-top: 20px;">
            <h2>{{ review.title }}</h2>
            </v-card-subtitle>
          <v-card-content>
            <v-textarea
              :value="review.content"
              readonly
              outlined
              rounded
              dense
              auto-grow
            >
            </v-textarea>
          </v-card-content>
          <br><br>
          <v-card-actions>
            <v-row class="d-flex align-end justify-center">
              <v-col cols="4">
                <template v-if="currentUser && user.id !== currentUser.id">
                  <template v-if="!isFavorite">
                    <v-btn
                      @click="addToFavorite"
                      class="mx-2"
                      fab
                      dark
                      small
                      color="pink"
                      outlined
                    >
                      <v-icon dark>
                        mdi-heart-plus-outline
                      </v-icon>
                    </v-btn>
                    ({{ review.favorite_reviews_count }})
                  </template>
                  <template v-else>
                    <v-btn
                      @click="removeFromFavorite"
                      class="mx-2"
                      fab
                      dark
                      small
                      color="pink"
                    >
                      <v-icon dark>
                        mdi-heart
                      </v-icon>
                    </v-btn>
                    ({{ review.favorite_reviews_count }})
                  </template>
                </template>
                <template v-else>
                  <v-icon>mdi-heart-multiple</v-icon>
                  いいね! ({{ review.favorite_reviews_count }})
                </template>
              </v-col>
              <v-col cols="4">
                <v-icon>mdi-calendar-clock</v-icon>
                {{ review.created_at }}
              </v-col>
            </v-row>
            <p>
            </p>
          </v-card-actions>
        </v-col>
        <v-col cols="2" class="d-flex flex-column" style="padding: 20px;">
          <template v-if="currentUser && user.id == currentUser.id">
            <v-btn @click="dialog=true" style="margin-bottom: 10px;">編集する</v-btn>
            <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
          </template>
        </v-col>
      </v-row>
    </v-card>

    <br><br>
    <v-row class="d-flex justify-space-between">
      <v-col cols="6" class="d-flex justify-start">
        <v-btn @click="previousReview" x-large><v-icon>mdi-arrow-left-bold</v-icon>前のレビュー</v-btn>
      </v-col>
      <v-col cols="6" class="d-flex justify-end">
        <v-btn @click="nextReview" x-large>次のレビュー<v-icon>mdi-arrow-right-bold</v-icon></v-btn>
      </v-col>
    </v-row>








    <br>



    <br><br>
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
  </div>
</template>

<script>

import EditReview from '../../../../components/reviews/EditReview.vue'
import axios from "@/plugins/axios"

export default {
  components: {
    EditReview
  },
  async asyncData({ params, store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const  [reviewResponse, reviewsResponse] = await Promise.all([
        axios.get(`/books/${params.book_id}/reviews/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get(`/books/${params.book_id}/reviews`)
      ])
        const book = reviewResponse.data.book
        const review = reviewResponse.data.review
        const user = reviewResponse.data.review_user
        const reviews = reviewsResponse.data
        console.log(reviewResponse.data)
        console.log(reviewsResponse.data)
      // console.log(responce.data.review.user)
      return {
        book,
        review,
        user,
        reviews,
        params
      }


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
      user: {},
      isFavorite: false,
      favoriteReviewId: "",

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

      const response = await axios.get("reviews/is_favorite", {
        params: {
          user_id: currentUserId,
          review_id: this.$route.params.id
        }
      })
      console.log(response)
      this.isFavorite = response.data.is_favorite
      this.favoriteReviewId = response.data.favorite_review_id
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
    async editReview(data) {
      try {
        const response = await axios.patch(`/books/${this.params.book_id}/reviews/${this.params.id}`, {
          title: data.title,
          content: data.content,
          rating: data.rating,
          current_user_id: this.currentUser.id
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
        const response = await axios.delete(`/books/${this.params.book_id}/reviews/${this.params.id}`, {
          params: { current_user_id: this.currentUser.id }
        })
        console.log(response)
        this.$router.push({ path: `/books/${this.book.id}`, query: { message: 'レビューを削除しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "レビューを削除できませんでした"
        this.dialog = false
      }
    },
    redirectToBook() {
      this.$router.push({ path: `/books/${this.book.id}` })
    },
    goToUser() {
      if( !this.currentUser || this.currentUser.id !== this.user.id ) {
        this.$router.push({ path: `/users/${this.user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
      }
    },
    async addToFavorite() {
      try {
        const response = await axios.post(`/reviews/${this.review.id}/favorite_reviews`, {
          user_id: this.currentUser.id
        })
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！しました"
        this.isFavorite = true
        this.favoriteReviewId = response.data.id
        this.review.favorite_reviews_count +=1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね！されています"
      }
    },
    async removeFromFavorite() {
      try {
        const response = await axios.delete(`/reviews/${this.review.id}/favorite_reviews/${this.favoriteReviewId}`, {
          params: {
            user_id: this.currentUser.id
          }
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね！を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteReviewId = null
        this.review.favorite_reviews_count -=1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね！されていません"
      }
    },
    nextReview() {
      const index = this.reviews.findIndex(item => item.id === this.review.id)
      const nextIndex = index + 1
      const nextReview = this.reviews[nextIndex]
      const lastItem = this.reviews[this.reviews.length - 1]
      if(this.review.id !== lastItem.id) {
        this.$router.push({ path: `/books/${this.book.id}/reviews/${nextReview.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最後のレビューです"
      }
    },
    previousReview() {
      const index = this.reviews.findIndex(item => item.id === this.review.id)
      const previousIndex = index - 1
      const previousReview = this.reviews[previousIndex]
      const firstItem = this.reviews[0]
      if(this.review.id !== firstItem.id) {
        this.$router.push({ path: `/books/${this.book.id}/reviews/${previousReview.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最初のレビューです"
      }
    }
  }
}
</script>

<style>

</style>

