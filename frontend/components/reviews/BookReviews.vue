<template>
  <div>
    <v-row mb-5 v-for="(review, index) in reviews" :key="'review_' + index" class="justify-center">
      <v-col cols="10">
        <v-card
          elevation="8"
          height="250"
        >
          <v-row>
            <v-col cols="2" class="mt-8">
              <div @click="goToUser(review.user)" style="cursor: pointer;">
              <v-row>
                <v-col class="d-flex justify-center align-center text-center">
                  <v-avatar size="100">
                    <v-img :src="review.user.image" alt="画像" contain></v-img>
                  </v-avatar>
                </v-col>
              </v-row>
              <v-row>
                <v-col class="d-flex justify-center align-center text-center">
                    <span style="text-decoration: underline;">{{ $truncate(review.user.name, 10) }}</span>
                  </v-col>
                </v-row>
              </div>
            </v-col>
            <v-col cols="9" class="mt-n2">
              <v-card-title>
                <nuxt-link :to="`/books/${review.book_id}/reviews/${review.id}`">{{ $truncate(review.title, 30) }}</nuxt-link>
              </v-card-title>
              <v-card-text >
                <v-textarea
                  :value="review.content"
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
                  <v-col cols="4">
                    <v-icon>mdi-comment-text-outline</v-icon>
                    返信: {{ review.replies_count }}
                  </v-col>
                  <v-col cols="4">
                    <v-icon>mdi-heart-multiple</v-icon>
                    いいね!: {{ review.favorite_questions_count }}
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


</div>
</template>

<script>
export default {
  props: {
    reviews: [],
  },
  computed: {
    currentUser() {
      return this.$store.getters["auth/getCurrentUser"]
    },
  },
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
