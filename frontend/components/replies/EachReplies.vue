<template>
  <div>
    <v-flex mb-5 v-for="(reply, index) in replies" :key="'reply_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/books/${reply.question.book_id}/questions/${reply.question_id}/replies/${reply.id}`">
            <v-row>
              <v-col cols="10">
                <v-card-text>
                  <p>{{ reply.content }}</p>
                </v-card-text>
                <v-card-actions>
                  by: {{ reply.user.name }}
                  <template v-if="reply.image">
                    <h5>画像</h5>
                    <v-icon>mdi-image-plus</v-icon>
                  </template>
                  <v-spacer></v-spacer>
                  to: {{ reply.question.title }}
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
    replies: [],
  },
}
</script>

<style>

</style>
