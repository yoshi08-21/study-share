<template>
  <div>
    <v-flex mb-5 v-for="(book, index) in books" :key="index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/books/${book.id}`">
            <v-row>
              <v-col cols="2">
                <template v-if="book.image">
                  <v-img :src="book.image" alt="画像"></v-img>
                </template>
              </v-col>
              <v-col cols="10">
                <v-card-title>タイトル: {{ book.name }}</v-card-title>
                <v-card-text>
                  <h4>著者: {{ book.author }}</h4>
                  <h4>出版社: {{ book.publisher }}</h4>
                </v-card-text>
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
    books: [],
  }
}
</script>

<style>

</style>
