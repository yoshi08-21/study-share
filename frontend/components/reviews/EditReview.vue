<template>
  <div>
    <br>
    <v-form>
      <v-rating
        v-model="editedRating"
        background-color="orange lighten-3"
        color="orange"
        large
        :label="rating"
      >
      </v-rating>
      <v-text-field counter label="タイトル" :rules="titleRules" v-model="editedTitle" data-cy="edit-title-field"></v-text-field>
      <v-textarea outlined counter label="本文" :rules="contentRules" v-model="editedContent" data-cy="edit-content-field"></v-textarea>

      <submit-button
        :error="error"
        :buttonTitle="'編集する'"
        @submitForm="submitForm"
        @closeDialog="$emit('closeDialog')"
      >
      </submit-button>

    </v-form>
  </div>
</template>

<script>
import { VTextField, VTextarea, VRating } from "vuetify/lib"
import SubmitButton from "../global/SubmitButton.vue"

export default {
  props: {
    rating: Number,
    title: String,
    content: String
  },
  components: {
    VTextField,
    VTextarea,
    VRating,
    SubmitButton,
  },
  data() {
    return {
      editedRating: this.rating,
      editedTitle: this.title,
      editedContent: this.content,
      titleRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || "").length <= 60 || "最大入力文字数は60文字です",
      ],
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || "").length <= 1000 || "最大入力文字数は1000文字です",
      ],
    }
  },
  methods: {
    submitForm() {
      this.$emit("submitReview", { title: this.editedTitle, content: this.editedContent, rating: this.editedRating })
    },
  }
}
</script>

<style>

</style>
