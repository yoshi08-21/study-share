<template>
  <div data-cy="favorite-section">
    <template v-if="currentUser && user.id !== currentUser.id">
      <template v-if="!isFavorite">
        <v-btn
          @click="addToFavorite"
          class="mx-2"
          fab
          dark
          small
          color="pink"
          outlined
          data-cy="add-favorite-button"
        >
          <v-icon dark>
            mdi-heart-plus-outline
          </v-icon>
        </v-btn>
        ({{ favoriteCount }})
      </template>
      <template v-else>
        <v-btn
          @click="removeFromFavorite"
          class="mx-2"
          fab
          dark
          small
          color="pink"
          data-cy="remove-favorite-button"
        >
          <v-icon dark>
            mdi-heart
          </v-icon>
        </v-btn>
        ({{ favoriteCount }})
      </template>
    </template>
    <template v-else>
      <v-icon>mdi-heart-multiple</v-icon>
      いいね! ({{ favoriteCount }})
    </template>
  </div>

</template>

<script>
export default {
  props: {
    currentUser: Object,
    user: Object,
    isFavorite: Boolean,
    favoriteCount: Number,


  },
  methods: {
    addToFavorite() {
      this.$emit("addToFavorite")
    },
    removeFromFavorite() {
      this.$emit("removeFromFavorite")
    }
  }
}
</script>

<style>

</style>
