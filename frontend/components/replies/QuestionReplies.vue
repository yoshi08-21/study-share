<template>
  <div>

    <v-row mb-5 v-for="(reply, index) in replies" :key="'reply_' + index" data-cy="each-question-replies">
      <v-col>
        <template v-if="reply.user_id !== reply.question.user_id">
          <!-- 質問の投稿者以外の返信 -->
          <v-row class="justify-start">
            <v-col cols="10">
              <v-card
                :to="`/books/${reply.question.book_id}/questions/${reply.question_id}/replies/${reply.id}`"
                elevation="8"
                height="200"
              >
                <v-row>
                  <v-col cols="2" class="mt-8">
                    <v-row>
                      <v-col class="d-flex justify-center align-center text-center">
                        <v-avatar size="80">
                          <v-img :src="reply.user.image" alt="画像" contain></v-img>
                        </v-avatar>
                      </v-col>
                    </v-row>
                    <v-row>
                      <v-col class="d-flex justify-center align-center text-center">
                        <span style="text-decoration: underline;">{{ $truncate(reply.user.name, 10) }}</span>
                      </v-col>
                    </v-row>
                  </v-col>
                  <v-col cols="9" class="mt-n2">
                    <v-card-text>
                      <v-textarea
                        :value="reply.content"
                        readonly
                        filled
                        rounded
                        dense
                        no-resize
                        rows="4"
                        style="height: 125px;"
                      >
                      </v-textarea>

                    </v-card-text>
                    <v-card-actions>

                      <v-row class="d-flex align-center justify-center">
                        <template v-if="reply.image">
                          <v-col cols="3">
                            <v-icon>mdi-file-image-plus</v-icon>
                            画像
                          </v-col>
                        </template>
                        <v-col cols="3">
                          <v-icon>mdi-heart-multiple</v-icon>
                          いいね! ({{ reply.favorite_replies_count }})
                        </v-col>
                        <v-col cols="3">
                          <v-icon>mdi-calendar-clock</v-icon>
                          {{ reply.created_at }}
                        </v-col>
                      </v-row>
                      <p>
                      </p>
                    </v-card-actions>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </template>

        <template v-else>
          <!-- 質問の投稿者の返信 -->
          <v-row class="justify-end">
            <v-col cols="10">
              <v-card
                :to="`/books/${reply.question.book_id}/questions/${reply.question_id}/replies/${reply.id}`"
                elevation="8"
                height="200"
                style="background-color: lightgreen;"
              >
                <v-row class="justify-end">
                  <v-col cols="9" class="mt-n2">
                    <v-card-text>
                      <v-textarea
                        :value="reply.content"
                        readonly
                        rounded
                        dense
                        no-resize
                        rows="4"
                        style="height: 125px; background-color: beige;"

                      >
                      </v-textarea>

                    </v-card-text>
                    <v-card-actions>

                      <v-row class="d-flex align-center justify-center">
                        <template v-if="reply.image">
                          <v-col cols="3">
                            <v-icon>mdi-file-image-plus</v-icon>
                            画像
                          </v-col>
                        </template>
                        <v-col cols="3">
                          <v-icon>mdi-heart-multiple</v-icon>
                          いいね! ({{ reply.favorite_replies_count }})
                        </v-col>
                        <v-col cols="3">
                          <v-icon>mdi-calendar-clock</v-icon>
                          {{ reply.created_at }}
                        </v-col>
                      </v-row>
                      <p>
                      </p>
                    </v-card-actions>
                  </v-col>
                  <v-col cols="2" class="mt-8">
                    <v-row>
                      <v-col class="d-flex justify-center align-center text-center">
                        <v-avatar size="80">
                          <v-img :src="reply.user.image" alt="画像" contain></v-img>
                        </v-avatar>
                      </v-col>
                    </v-row>
                    <v-row>
                      <v-col class="d-flex justify-center align-center text-center">
                        <span style="text-decoration: underline;">{{ $truncate(reply.user.name, 10) }}</span>
                      </v-col>
                    </v-row>
                  </v-col>
                </v-row>
              </v-card>
            </v-col>
          </v-row>
        </template>
      </v-col>
    </v-row>


  </div>
</template>

<script>
import userComputed from '../../mixins/userComputed'

export default {
  props: {
    replies: [],
  },
  mixins: [userComputed],
  methods: {
    goToUser(user) {
      if( !this.currentUser || this.currentUser.id !== user.id ) {
        this.$router.push({ path: `/users/${user.id}` })
      } else {
        this.$router.push({ path: "/mypage" })
      }
    },

  }

}
</script>

<style>

</style>
