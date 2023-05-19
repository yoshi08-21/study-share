<template>
  <div>
    <h1>ユーザー情報を編集する</h1>
    <v-form>
      <v-text-field counter label="名前" :rules="nameRules" v-model="editedName"></v-text-field>
      <v-textarea outlined counter label="自己紹介" :rules="contentRules" v-model="editedIntroduction"></v-textarea>
      <v-text-field counter label="第一志望" :rules="schoolNameRules" v-model="editedFirstChoiceSchool"></v-text-field>
      <v-text-field counter label="第二志望" :rules="schoolNameRules" v-model="editedSecondChoiceSchool"></v-text-field>
      <v-text-field counter label="第三志望" :rules="schoolNameRules" v-model="editedThirdChoiceSchool"></v-text-field>

      <v-row>
        <v-col cols="2" class="align-start custom-button-margin">
          <v-btn color="primary" @click="submitForm">編集する</v-btn>
        </v-col>
        <v-col cols="2" class="align-start">
          <v-btn @click="$emit('closeDialog')">閉じる</v-btn>
        </v-col>
        <v-col cols="8" class="text-right">
          <!-- ダイアログの表示を挟む -->
          <v-btn color="error" class="justify-end" @click="showDeleteConfirmation=true">ユーザーを削除する</v-btn>
        </v-col>
      </v-row>

      <!-- ユーザー削除確認ダイアログ -->
      <v-dialog v-model="showDeleteConfirmation">
      <v-card>
        <v-card-title>
          削除されたユーザーは復元することができません！
        </v-card-title>
        <v-card-text>
          <strong>
            ユーザーを削除しますか？
          </strong>
        </v-card-text>
        <v-card-actions class="justify-content-center">
          <v-btn @click="deleteLocalUser">削除する</v-btn>
          <v-btn @click="showDeleteConfirmation=false">戻る</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>


    </v-form>
  </div>
</template>

<script>
import { VTextField, VTextarea} from 'vuetify/lib'

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
      ],
      showDeleteConfirmation: false,

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
    deleteLocalUser() {
      this.$emit("deleteUser")
    }
  }
}
</script>

<style>

.custom-button-margin {
  margin-right: -30px;
}

</style>
