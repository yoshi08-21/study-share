<template>
  <div>
    <v-flex mb-5 v-for="(question, index) in questions" :key="'question_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/books/${question.book_id}/questions/${question.id}`">
            <v-row>
              <v-col cols="2">
                <template v-if="question.image">
                  <v-img :src="question.image" alt="画像"></v-img>
                </template>
              </v-col>
              <v-col cols="10">
                <v-card-title>タイトル: {{ question.title }}</v-card-title>
                <v-card-text>
                  <p>{{ question.content }}</p>
                </v-card-text>
                <v-card-actions>
                  by: {{ question.user.name }}
                  <v-spacer></v-spacer>
                  to: {{ question.book.name }}
                  <v-col cols="2">
                    <template v-if="question.book.image">
                      <v-img :src="question.book.image" alt="画像"></v-img>
                    </template>
                  </v-col>
                </v-card-actions>
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
    questions: [],
  }
}
</script>

<style>

</style>
