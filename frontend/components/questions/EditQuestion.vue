<template>
  <div>
    <h1>質問を編集する</h1>
    <v-form>
      <v-text-field counter label="タイトル" :rules="titleRules" v-model="editedTitle"></v-text-field>
      <v-textarea outlined counter label="本文" :rules="contentRules" v-model="editedContent"></v-textarea>
      <br>
      *添付できる画像のファイルサイズは3MBまでです
      <br><br>
      <v-file-input
        v-model="selectedFile"
        accept="image/jpeg, image/png"
        show-size
        truncate-length="15"
        outlined
        label="ファイルを選択"
        prepend-icon="mdi-image-plus"
        style="width: 500px;"
        @change="checkFileSize"
      ></v-file-input>
      <template v-if="errorMessage">
        <v-alert type="error" dense text border="left">
          {{ errorMessage }}
        </v-alert>
      </template>
      <v-row>
        <v-col cols="2" class="align-start custom-button-margin">
          <template v-if="error === true">
            <v-btn color="primary" disabled @click="submitForm">投稿する</v-btn>
          </template>
          <template v-else>
            <v-btn color="primary" @click="submitForm">投稿する</v-btn>
          </template>
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
  props: {
    title: String,
    content: String
  },
  components: {
    VTextField,
    VTextarea,
  },
  data() {
    return {
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
      selectedFile: null,
      errorMessage: "",
      error: false
    }
  },
  methods: {
    submitForm() {
      this.$emit('submitQuestion', { title: this.editedTitle, content: this.editedContent, image: this.selectedFile })
    },
    checkFileSize(file) {
      console.log(file)
      const maxSize = 3145728
      if (file && file.size > maxSize) {
        this.errorMessage = "添付できるファイルは3MBまでです"
        this.error = true
      } else {
        this.errorMessage = ""
        this.error = false
      }
    }
  }

}
</script>

<style>

</style>
