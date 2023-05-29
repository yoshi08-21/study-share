<template>
  <div>
    <br>
    <v-flex mb-5 v-for="(review, index) in reviews" :key="'review_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/books/${review.book_id}/reviews/${review.id}`">
            <v-row>
              <v-col cols="10">
                <v-card-title>
                  タイトル: {{ review.title }}
                  評価：<v-rating v-model="review.rating" :readonly="true" background-color="orange lighten-3" color="orange"></v-rating>({{ review.rating }})
                </v-card-title>
                <v-card-text>
                  <p>{{ review.content }}</p>
                </v-card-text>
                <v-card-actions>
                  by: {{ review.user.name }}
                </v-card-actions>
              </v-col>
              <v-col cols="2">
                to: {{ review.book.name }}
                <template v-if="review.book.image">
                  <v-img :src="review.book.image" alt="画像"></v-img>
                </template>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-flex>

</div>
</template>

<script>
export default {
  props: {
    reviews: [],
  }
}
</script>

<style>

</style>
