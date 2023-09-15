<template>
  <div>
    <br><br>
    <v-form>
      <v-textarea outlined counter label="本文" :rules="contentRules" v-model="editedContent" data-cy="edit-content-field"></v-textarea>
      *画像を添付できます(「.jpeg」「.jpg」「.png」のみ添付できます)
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
import { VTextarea } from "vuetify/lib"
import SubmitButton from "../global/SubmitButton.vue"

export default {
  props: {
    content: String
  },
  components: {
    VTextarea,
    SubmitButton,
  },
  data() {
    return {
      editedContent: this.content,
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || "").length <= 1000 || "最大入力文字数は1000文字です",
      ],
      selectedFile: null,
      errorMessage: "",
      error: false
    }
  },
  methods: {
    submitForm() {
      this.$emit("submitReply", { content: this.editedContent, image: this.selectedFile })
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
