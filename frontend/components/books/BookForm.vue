<template>
  <div>
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
      <v-text-field counter label="タイトル" :rules="titleRules" v-model="name"></v-text-field>
      <v-text-field counter label="著者" :rules="authorRules" v-model="author"></v-text-field>
      <v-text-field counter label="出版社" :rules="publisherRules" v-model="publisher"></v-text-field>
      <v-row>
        <v-col cols="2" class="align-start custom-button-margin">
          <v-btn color="primary" @click="submitForm"> 登録する</v-btn>
        </v-col>
        <v-col cols="2" class="align-start">
          <v-btn @click="$emit('closeDialog')">閉じる</v-btn>
        </v-col>
      </v-row>
    </v-form>
  </div>
</template>

<script>
import { VTextField } from 'vuetify/lib'

export default {
  components: {
    VTextField,
  },
  data() {
    return {
      name: "",
      author: "",
      publisher: "",
      subject: "",
      titleRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || '').length <= 60 || "最大入力文字数は60文字です",
      ],
      authorRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || '').length <= 25 || "最大入力文字数は25文字です",
      ],
      publisherRules: [
        value => (value || '').length <= 25 || "最大入力文字数は25文字です",
      ],
      items: ["英語", "数学", "国語", "社会", "理科" ]
    }
  },
  methods: {
    submitForm() {
      this.$emit('submitBook', { name: this.name, author: this.author, publisher: this.publisher, subject: this.subject })
      this.name = ""
      this.author = ""
      this.publisher = ""
      this.subject = ""
    },
  }
}
</script>

<style>

</style>
