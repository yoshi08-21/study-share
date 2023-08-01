<template>
  <div>
    <v-form>
      <v-col
        class="d-flex"
        cols="12"
        sm="6"
      >
      <v-select
        :items="genres"
        v-model="selectedGenre"
        label="ジャンル"
        outlined
      ></v-select>
    </v-col>
      <v-text-field counter label="タイトル（必須）" :rules="titleRules" v-model="title"></v-text-field>
      <v-text-field counter label="本文（必須）" :rules="contentRules" v-model="content"></v-text-field>
      <v-text-field counter label="選択肢1（必須）" :rules="requiredOptionRules" v-model="option1"></v-text-field>
      <v-text-field counter label="選択肢2（必須）" :rules="requiredOptionRules" v-model="option2"></v-text-field>
      <v-text-field counter label="選択肢3（任意）" :rules="optionRules" v-model="option3"></v-text-field>
      <v-text-field counter label="選択肢4（任意）" :rules="optionRules" v-model="option4"></v-text-field>
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
      titleRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || '').length <= 60 || "最大入力文字数は60文字です",
      ],
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || '').length <= 1000 || "最大入力文字数は1000文字です",
      ],
      requiredOptionRules: [
        value => !!value || "選択肢を入力してください",
        value => (value || '').length <= 50 || "最大入力文字数は50文字です",
      ],
      optionRules: [
        value => (value || '').length <= 50 || "最大入力文字数は50文字です",
      ],
      genres: ["国語", "社会", "数学", "英語", "理科", "参考書", "進路・大学", "その他"],
      selectedGenre: "",
      title: "",
      content: "",
      option1: "",
      option2: "",
      option3: "",
      option4: "",


    }
  },
  methods: {
    submitForm() {
      const survey = {
        title: this.title,
        content: this.content,
        genre: this.selectedGenre,
        option1: this.option1,
        option2: this.option2,
      }

      if(this.option3 !== "") {
        survey.option3 = this.option3
      }

      if(this.option4 !== "") {
        survey.option4 = this.option4
      }
      this.$emit('submitSurvey', survey)
    },
  }
}
</script>

<style>

</style>
