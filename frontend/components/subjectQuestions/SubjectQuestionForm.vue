<template>
  <div>
    <h1>質問を投稿する</h1>
    <v-form>
      <v-col
        class="d-flex"
        cols="12"
        sm="6"
      >
        <v-select
          v-model="subject"
          :items="items"
          label="科目"
          dense
          outlined
        ></v-select>
      </v-col>
      <v-text-field counter label="タイトル" :rules="titleRules" v-model="title"></v-text-field>
      <v-textarea outlined counter label="本文" :rules="contentRules" v-model="content"></v-textarea>
      <v-row>
        <v-col cols="2" class="align-start custom-button-margin">
          <v-btn color="primary" @click="submitForm">投稿する</v-btn>
        </v-col>
        <v-col cols="2" class="align-start">
          <v-btn @click="$emit('closeDialog')">閉じる</v-btn>
        </v-col>
      </v-row>
    </v-form>
  </div>
</template>

<script>
import { VTextField, VTextarea } from 'vuetify/lib'

export default {
  components: {
    VTextField,
    VTextarea,
  },
  data() {
    return {
      title: "",
      content: "",
      subject: "",
      items: ["英語", "数学", "国語", "社会", "理科" ],
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
      this.$emit('submitSubjectQuestion', { title: this.title, content: this.content, subject: this.subject })
    },
  }
}
</script>

<style>

</style>
