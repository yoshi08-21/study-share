<template>
  <div>
    <h3>レビュー一覧</h3>

    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(review, index) in reviews" :key="index">
    <a href="" style="text-decoration: none;">
      <v-card :to="`${book_id}/reviews/${review.id}`">
        <v-card-title>{{ review.title }} 評価：{{ review.rating }}</v-card-title>
        <v-card-text>{{ review.content }}</v-card-text>
        <template v-if="review.user">
          <v-card-actions>by:{{ review.user.name }}</v-card-actions>
        </template>
      </v-card>
    </a>

    </v-flex>
  </div>
</template>

<script>
export default {
  props: {
    reviews: [],
    book_id: Number
  }
}
</script>

<style>

</style>
