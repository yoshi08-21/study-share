<template>
  <div>
    <h1>返信を編集する</h1>
    <br>
    <v-form>
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
import { VTextarea } from 'vuetify/lib'

export default {
  props: {
    content: String
  },
  components: {
    VTextarea,
  },
  data() {
    return {
      editedContent: this.content,
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || '').length <= 1000 || "最大入力文字数は1000文字です",
      ],
    }
  },
  methods: {
    submitForm() {
      this.$emit('submitReply', { content: this.editedContent })
    },
  }
}
</script>

<style>

</style>
