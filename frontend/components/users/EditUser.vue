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
      <v-text-field counter label="名前" :rules="nameRules" v-model="editedName"></v-text-field>
      <v-textarea outlined counter label="自己紹介" :rules="contentRules" v-model="editedIntroduction"></v-textarea>
      <v-text-field counter label="第一志望" :rules="schoolNameRules" v-model="editedFirstChoiceSchool"></v-text-field>
      <v-text-field counter label="第二志望" :rules="schoolNameRules" v-model="editedSecondChoiceSchool"></v-text-field>
      <v-text-field counter label="第三志望" :rules="schoolNameRules" v-model="editedThirdChoiceSchool"></v-text-field>

      <template v-if="errorMessage">
        <v-alert type="error" dense text border="left">
          {{ errorMessage }}
        </v-alert>
      </template>
      <v-row>
        <v-col cols="3" class="align-start custom-button-margin">
          <template v-if="error === true">
            <v-btn color="primary" disabled @click="submitForm" width="250">編集する</v-btn>
          </template>
          <template v-else>
            <v-btn color="primary" @click="submitForm" width="250">編集する</v-btn>
          </template>
        </v-col>
        <v-col cols="3" class="align-start">
          <v-btn @click="$emit('closeDialog')" width="250">閉じる</v-btn>
        </v-col>
        <v-col cols="6" class="text-right">
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
    },
  }
}
</script>

<style>

.custom-button-margin {
  margin-right: -30px;
}

</style>
