<template>
  <div>
    <h1>ユーザー情報を編集する</h1>
    <v-form>
      <v-text-field counter label="名前" :rules="nameRules" v-model="editedName"></v-text-field>
      <v-textarea outlined counter label="自己紹介" :rules="contentRules" v-model="editedIntroduction"></v-textarea>
      <v-text-field counter label="第一志望" :rules="schoolNameRules" v-model="editedFirstChoiceSchool"></v-text-field>
      <v-text-field counter label="第二志望" :rules="schoolNameRules" v-model="editedSecondChoiceSchool"></v-text-field>
      <v-text-field counter label="第三志望" :rules="schoolNameRules" v-model="editedThirdChoiceSchool"></v-text-field>
      <v-btn color="primary" @click="submitForm">編集する</v-btn>
      <v-btn @click="$emit('closeDialog')">閉じる</v-btn>
    </v-form>
  </div>
</template>

<script>
import { VTextField, VTextarea } from 'vuetify/lib'

export default {
  props: {
    name: String,
    introduction: String,
    first_choice_school: String,
    second_choice_school: String,
    third_choice_school: String
  },
  components: {
    VTextField,
    VTextarea,
  },
  data() {
    return {
      editedName: this.name,
      editedIntroduction: this.introduction,
      editedFirstChoiceSchool: this.first_choice_school,
      editedSecondChoiceSchool: this.second_choice_school,
      editedThirdChoiceSchool: this.third_choice_school,
      nameRules: [
        value => !!value || "名前を入力してください",
        value => (value || '').length <= 30 || "最大入力文字数は30文字です",
      ],
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || '').length <= 200 || "最大入力文字数は200文字です",
      ],
      schoolNameRules: [
      value => (value || '').length <= 30 || "最大入力文字数は30文字です",
      ]
    }
  },
  methods: {
    submitForm() {
      this.$emit('editUser', {
        name: this.editedName,
        introduction: this.editedIntroduction,
        firstChoiceSchool: this.editedFirstChoiceSchool,
        secondChoiceSchool: this.editedSecondChoiceSchool,
        thirdChoiceSchool: this.editedThirdChoiceSchool,
      })
    },
  }
}
</script>

<style>

</style>
