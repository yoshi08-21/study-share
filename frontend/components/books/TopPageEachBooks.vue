<template>
  <v-sheet>
    <v-slide-group multiple show-arrows>
      <v-slide-group>
        <v-slide-item v-for="book in books" :key="book.id">
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
                  <h4>科目: {{ book.subject }}</h4>
                </v-card-text>
              </v-col>
            </v-row>
            <v-card-actions>
              レビュー:{{ book.reviews_count }}件
              平均評価:{{ book.average_rating }}
              お気に入り: {{ book.favorite_books_count }}
            </v-card-actions>
          </v-card>
        </v-slide-item>
      </v-slide-group>
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
