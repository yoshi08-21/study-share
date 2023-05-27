<template>
  <div>
    <v-flex xs12 sm6 md4 lg3 mb-5 v-for="(book, index) in books" :key="index">
      <v-card :to="`/books/${book.id}`">
        <v-card-title>タイトル: {{ book.name }}</v-card-title>
        <v-card-title>著者: {{ book.author }}</v-card-title>
        <v-card-title>出版社: {{ book.publisher }}</v-card-title>
      </v-card>
    </v-flex>
  </div>
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
