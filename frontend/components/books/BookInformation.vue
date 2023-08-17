<template>
  <v-card
    min-height="300"
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
                v-model="bookAverageRating"
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

        <v-card-text>
          <h3 style="margin-bottom: 5px;">科目: {{ book.subject }}</h3>
          <h4>作者: {{ book.author }}</h4>
          <h4>出版社: {{ book.publisher }}</h4>
        </v-card-text>
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

</template>

<script>
export default {
  props: {
    book: Object
  },
  data() {
    return {
      bookAverageRating: this.book.average_rating
    }
  }
}
</script>

<style>

</style>
