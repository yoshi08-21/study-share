<template>
  <div>
    <h3>返信一覧</h3>

    <v-flex v-for="(reply, index) in replies" :key="index" xs12 sm6 md4 lg3 mb-5>
      <v-card :to="`/books/${book_id}/questions/${reply.question_id}/replies/${reply.id}`">
        <v-card-text>{{ reply.content }}</v-card-text>
        <template v-if="reply.user">
          <v-card-actions>by:{{ reply.user.name }}</v-card-actions>
        </template>
      </v-card>
    </v-flex>
  </div>
</template>

<script>
export default {
  props: {
    replies: [],
    book_id: Number
  },
  created() {
    console.log()
  }
}
</script>

<style>

</style>
