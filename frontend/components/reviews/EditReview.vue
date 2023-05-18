<template>
  <div>
    <h1>レビューを編集する</h1>
    <v-form>
      <v-rating
        v-model="editedRating"
        background-color="orange lighten-3"
        color="orange"
        large
        :label="rating"
      >
      </v-rating>
      <v-text-field counter label="タイトル" :rules="titleRules" v-model="editedTitle"></v-text-field>
      <v-textarea outlined counter label="本文" :rules="contentRules" v-model="editedContent"></v-textarea>


      <v-row>
        <v-col cols="2" class="align-start custom-button-margin">
          <v-btn color="primary" @click="submitForm">編集する</v-btn>
        </v-col>
        <v-col cols="2" class="align-start">
          <v-btn @click="$emit('closeDialog')">閉じる</v-btn>
        </v-col>
      </v-row>




    </v-form>
  </div>
</template>

<script>
import { VTextField, VTextarea, VRating } from 'vuetify/lib'

export default {
  props: {
    rating: Number,
    title: String,
    content: String
  },
  components: {
    VTextField,
    VTextarea,
    VRating
  },
  data() {
    return {
      editedRating: this.rating,
      editedTitle: this.title,
      editedContent: this.content,
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
      this.$emit('submitReview', { title: this.editedTitle, content: this.editedContent, rating: this.editedRating })
    },
  }
}
</script>

<style>

</style>
