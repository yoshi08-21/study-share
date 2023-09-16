<template>
  <div>
    <br><br>
    <v-form>
      <v-file-input
        v-model="selectedFile"
        accept="image/jpeg, image/png"
        show-size
        truncate-length="15"
        outlined
        label="プロフィール画像を登録"
        prepend-icon="mdi-image-plus"
        style="width: 500px;"
        @change="checkFileSize"
      ></v-file-input>
      *画像は「.jpeg」「.jpg」「.png」のみ登録できます
      <br>
      *登録できる画像のファイルサイズは3MBまでです

      <br><br>
      <v-text-field counter label="名前" :rules="nameRules" v-model="editedName" data-cy="edit-name-field"></v-text-field>
      <v-textarea outlined counter label="自己紹介" :rules="contentRules" v-model="editedIntroduction" data-cy="edit-introduction-field"></v-textarea>

      <br>
      *大学名は国立・私立などを除いた正式名称で入力してください  例） ◯東京大学 | ☓東大 ☓国立東京大学
      <v-text-field counter label="第一志望" :rules="schoolNameRules" v-model="editedFirstChoiceSchool" data-cy="edit-first-choice-school-field"></v-text-field>
      <v-text-field counter label="第二志望" :rules="schoolNameRules" v-model="editedSecondChoiceSchool" data-cy="edit-second-choice-school-field"></v-text-field>
      <v-text-field counter label="第三志望" :rules="schoolNameRules" v-model="editedThirdChoiceSchool" data-cy="edit-third-choice-school-field"></v-text-field>

      <template v-if="errorMessage">
        <v-alert type="error" dense text border="left">
          {{ errorMessage }}
        </v-alert>
      </template>
      <br>
      <v-row>
        <v-col cols="3" class="align-start custom-button-margin">
          <template v-if="error === true">
            <v-btn color="primary" disabled @click="submitForm" width="250" data-cy="submit-button">編集する</v-btn>
          </template>
          <template v-else>
            <v-btn color="primary" @click="submitForm" width="250" data-cy="submit-button">編集する</v-btn>
          </template>
        </v-col>
        <v-col cols="3" class="align-start">
          <v-btn @click="$emit('closeDialog')" width="250">閉じる</v-btn>
        </v-col>
        <v-col cols="6" class="text-right">
          <!-- ダイアログの表示を挟む -->
          <v-btn color="error" class="justify-end" @click="showDeleteConfirmation=true" data-cy="delete-button">ユーザーを削除する</v-btn>
        </v-col>
      </v-row>

      <!-- ユーザー削除確認ダイアログ -->
      <delete-confirmation-dialog
        :showDeleteConfirmation="showDeleteConfirmation"
        :contentTitle="'ユーザー'"
        @deleteContent="deleteLocalUser"
        @closeDeleteConfirmation="showDeleteConfirmation = false"
      >
      </delete-confirmation-dialog>


    </v-form>
  </div>
</template>

<script>
import { VTextField, VTextarea} from "vuetify/lib"
import DeleteConfirmationDialog from "../global/DeleteConfirmationDialog.vue"
import sharedMethods from "../../mixins/sharedMethods"

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
    DeleteConfirmationDialog,
  },
  mixins: [sharedMethods],
  data() {
    return {
      editedName: this.name,
      editedIntroduction: this.introduction,
      editedFirstChoiceSchool: this.first_choice_school,
      editedSecondChoiceSchool: this.second_choice_school,
      editedThirdChoiceSchool: this.third_choice_school,
      nameRules: [
        value => !!value || "名前を入力してください",
        value => (value || "").length <= 30 || "最大入力文字数は30文字です",
      ],
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || "").length <= 200 || "最大入力文字数は200文字です",
      ],
      schoolNameRules: [
      value => (value || "").length <= 30 || "最大入力文字数は30文字です",
      ],
      showDeleteConfirmation: false,
      selectedFile: null,
      errorMessage: "",
      error: false,


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
        image: this.selectedFile
      })
    },
    deleteLocalUser() {
      this.$emit("deleteUser")
    },
  }
}
</script>

<style>

.custom-button-margin {
  margin-right: -30px;
}

</style>
