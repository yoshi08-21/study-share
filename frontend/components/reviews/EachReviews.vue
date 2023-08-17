<template>
  <div>
    <v-row mb-5 v-for="(review, index) in reviews" :key="'review_' + index" class="justify-center">
      <v-col cols="10">
        <v-card
          elevation="8"
          height="260"
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
            <v-col cols="7" class="mt-n2">
              <v-card-title>
                <nuxt-link :to="`/books/${review.book_id}/reviews/${review.id}`">{{ $truncate(review.title, 30) }}</nuxt-link>
              </v-card-title>
              <v-card-subtitle style="margin-top: -20px;">
                  <v-row class="d-flex align-center">
                    <v-col cols="3">
                      <v-rating
                        v-model="review.rating"
                        :readonly="true"
                        background-color="orange lighten-3"
                        color="orange"
                        dense
                      >
                      </v-rating>
                    </v-col>
                    <v-col cols="2">
                      <h2>
                        ({{ review.rating }})
                      </h2>
                    </v-col>
                  </v-row>
                </v-card-subtitle>
              <v-card-text>
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
              <v-card-actions style="margin-top: -20px;">
                <v-row class="d-flex align-center justify-center">
                  <v-col cols="4">
                    <v-icon>mdi-heart-multiple</v-icon>
                    いいね! ({{ review.favorite_reviews_count }})
                  </v-col>
                  <v-col cols="4">
                    <v-icon>mdi-calendar-clock</v-icon>
                    {{ review.created_at }}
                  </v-col>
                </v-row>
                <p>
                </p>
              </v-card-actions>
            </v-col>
            <v-col cols="3">
              <div style="height: 250px;">
                <v-row style="flex-direction: column; height: 150px; width: 220px;">
                  <v-col class="d-flex justify-center align-center">
                    <v-img
                      :src="review.book.image"
                      alt="画像"
                      contain
                      height="150"
                      width="220"
                    >
                    </v-img>
                  </v-col>
                </v-row>
                <v-row>
                  <v-col class="d-flex justify-center align-center mt-2">
                    <nuxt-link :to="`/books/${review.book_id}}`">{{ $truncate(review.book.name, 25) }}</nuxt-link>
                  </v-col>
                </v-row>
              </div>
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
