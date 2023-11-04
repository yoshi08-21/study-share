<template>
  <div>
    <div style="margin-bottom: 10px;">
      <h3>参考書情報</h3>
    </div>
    <book-information :book="book"></book-information>

    <br><br><br>
    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>レビュー詳細</h2>
      <nuxt-link :to="`/books/${book.id}`">参考書詳細に戻る</nuxt-link>
    </div>
    <v-card
      elevation="8"
      style="padding-bottom: 1px;"
      data-cy="review-detail"
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

          <v-card-text>
            <v-textarea
              :value="review.content"
              readonly
              outlined
              rounded
              dense
              auto-grow
            >
            </v-textarea>
          </v-card-text>

          <br>
          <v-card-actions>
            <v-row class="d-flex align-end justify-center">
              <v-col cols="4">
                <favorite-button
                  :currentUser="currentUser"
                  :user="user"
                  :isFavorite="isFavorite"
                  :favoriteCount="review.favorite_reviews_count"
                  @addToFavorite="addToFavorite"
                  @removeFromFavorite="removeFromFavorite"
                >
                </favorite-button>
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
    <content-navigator
      :content="'レビュー'"
      @previousContent="previousReview"
      @nextContent="nextReview"
    >
    </content-navigator>


    <!-- レビュー編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title style="justify-content: center;">
          <h2>レビューを編集する</h2>
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
    <delete-confirmation-dialog
      :showDeleteConfirmation="showDeleteConfirmation"
      :contentTitle="'レビュー'"
      @deleteContent="deleteReview"
      @closeDeleteConfirmation="showDeleteConfirmation = false"
    >
    </delete-confirmation-dialog>


    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import EditReview from '../../../../components/reviews/EditReview.vue'
import BookInformation from '../../../../components/books/BookInformation.vue'
import FavoriteButton from '../../../../components/global/FavoriteButton.vue'
import ContentNavigator from '../../../../components/global/ContentNavigator.vue'
import DeleteConfirmationDialog from '../../../../components/global/DeleteConfirmationDialog.vue'
import userComputed from '../../../../mixins/userComputed'
import flashMessage from '../../../../mixins/flashMessage'
import navigationMethods from '../../../../mixins/navigationMethods'

import axios from "@/plugins/axios"

export default {
  head: {
    title: "レビュー詳細",
  },
  components: {
    EditReview,
    BookInformation,
    FavoriteButton,
    ContentNavigator,
    DeleteConfirmationDialog,
  },
  mixins: [userComputed, flashMessage, navigationMethods],
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
      return {
        book,
        review,
        user,
        reviews,
        params
      }
    } catch(error) {
      console.error("エラーが発生しました:", error)
    }
  },
  data() {
    return {
      dialog: false,
      showDeleteConfirmation: false,
      user: {},
      isFavorite: false,
      favoriteReviewId: "",
    }
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
          current_user_id: currentUserId,
          review_id: this.$route.params.id
        }
      })
      this.isFavorite = response.data.is_favorite
      this.favoriteReviewId = response.data.favorite_review_id
    } catch(error) {
      console.error("エラーが発生しました:", error)
    }
  },
  methods: {
    async editReview(data) {
      try {
        const response = await axios.patch(`/books/${this.book.id}/reviews/${this.review.id}`, {
          review: {
            title: data.title,
            content: data.content,
            rating: data.rating,
          },
          current_user_id: this.currentUser.id
        })
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "レビューの編集が完了しました"
        this.review.title = response.data.title
        this.review.content = response.data.content
        this.review.rating = response.data.rating
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "レビューを編集できませんでした"
      }
      this.dialog = false
    },
    async deleteReview() {
      try {
        await axios.delete(`/books/${this.book.id}/reviews/${this.review.id}`, {
          params: {
            current_user_id: this.currentUser.id
          }
        })
        this.$router.push({ path: `/books/${this.book.id}`, query: { message: 'レビューを削除しました' } })
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "レビューを削除できませんでした"
        this.dialog = false
      }
    },
    async addToFavorite() {
      try {
        const response = await axios.post(`/reviews/${this.review.id}/favorite_reviews`, {
          current_user_id: this.currentUser.id
        })
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね!しました"
        this.isFavorite = true
        this.favoriteReviewId = response.data.id
        this.review.favorite_reviews_count +=1
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね!されています"
      }
    },
    async removeFromFavorite() {
      try {
        await axios.delete(`/reviews/${this.review.id}/favorite_reviews/${this.favoriteReviewId}`, {
          params: {
            current_user_id: this.currentUser.id
          }
        })
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね!を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteReviewId = null
        this.review.favorite_reviews_count -=1
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね!されていません"
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

