<template>
  <div>
    <h3>レビュー一覧</h3>

    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(review, index) in reviews" :key="index">

    <v-card >
      <v-card-title>{{ review.title }} 評価：{{ review.rating }}</v-card-title>
      <v-card-text>{{ review.content }}</v-card-text>
    </v-card>

    </v-flex>
  </div>
</template>

<script>
export default {
  props: {
    reviews: []
  }
}
</script>

<style>

</style>
