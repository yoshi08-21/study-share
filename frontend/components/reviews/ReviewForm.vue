<template>
  <div>
    <br>
    <v-form>
      <v-rating
        v-model="rating"
        background-color="orange lighten-3"
        color="orange"
        large
      >
      </v-rating>
      <v-text-field counter label="タイトル" :rules="titleRules" v-model="title"></v-text-field>
      <v-textarea outlined counter label="本文" :rules="contentRules" v-model="content"></v-textarea>
      <submit-button
        :buttonTitle="'投稿する'"
        @submitForm="submitForm"
        @closeDialog="$emit('closeDialog')"
      >
      </submit-button>
    </v-form>
  </div>
</template>

<script>
import { VTextField, VTextarea, VRating } from 'vuetify/lib'
import SubmitButton from '../global/SubmitButton.vue'

export default {
  components: {
    VTextField,
    VTextarea,
    VRating,
    SubmitButton
  },
  data() {
    return {
      rating: 1,
      title: "",
      content: "",
      titleRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || '').length <= 60 || "最大入力文字数は60文字です",
      ],
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || '').length <= 1000 || "最大入力文字数は1000文字です",
      ],
    }
  },
  methods: {
    submitForm() {
      this.$emit('submitReview', { title: this.title, content: this.content, rating: this.rating })
    },
  }
}
</script>

<style>

</style>
