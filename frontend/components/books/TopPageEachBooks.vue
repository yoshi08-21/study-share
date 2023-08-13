<template>
  <v-sheet class="mx-auto">
    <v-slide-group
      center-active
      show-arrows
      style="background-color: #edebe8;"
    >
      <v-slide-item v-for="book in books" :key="book.id" v-slot="{ toggle }">
        <v-card
          height="430"
          width="370"
          outlined
          class="ma-4 pa-4"
          @click="toggle"
          raised
          shaped
        >
          <div v-if="book.image" class="d-flex justify-center" style="height: 150px;">
              <v-img
                :src="book.image"
                alt="画像"
                contain
                max-height="150"
                max-width="150"
              >
              </v-img>
          </div>
          <br>
          <v-card-title style="height: 90px;">
            <nuxt-link :to="`/books/${book.id}`">{{ $truncate(book.name, 25) }}</nuxt-link>
          </v-card-title>
          <div>
            <div>
              <v-row class="d-flex align-center">
                <v-col cols="3">
                  <h4>平均評価</h4>
                </v-col>
                <v-col cols="7">
                  <v-rating
                    v-model="book.average_rating"
                    :readonly="true"
                    background-color="orange lighten-3"
                    color="orange"
                    dense
                    large
                    half-increments
                  >
                  </v-rating>
                </v-col>
                <v-col cols="2">
                  ({{ book.average_rating }})
                </v-col>
              </v-row>
            </div>
            <div>
              <v-row class="d-flex align-center justify-center">
                <v-col cols="12" class="d-flex align-center justify-center">
                  <h3>科目: {{ book.subject }}</h3>
                </v-col>
              </v-row>
            </div>
          </div>
          <v-card-actions style="margin-top: 10px;">
            <v-row>
              <v-col cols="6">
                <v-icon>mdi-comment-text-outline</v-icon>
                レビュー:{{ book.reviews_count }}件
              </v-col>
              <v-col cols="6">
                <v-icon>mdi-heart-multiple</v-icon>
                お気に入り: {{ book.favorite_books_count }}
              </v-col>
            </v-row>
          </v-card-actions>
        </v-card>
      </v-slide-item>
    </v-slide-group>
  </v-sheet>
</template>

<script>
export default {
  props: {
    books: [],
  }
}
</script>

<style>

</style>
