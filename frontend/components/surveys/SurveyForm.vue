<template>
  <div>
    <br><br>
    <v-form>
      <v-col
        class="d-flex"
        cols="12"
        sm="6"
      >
      <v-select
        :items="genres"
        v-model="selectedGenre"
        label="ジャンル(必須)"
        outlined
        data-cy="select-genre-button"
      ></v-select>
    </v-col>
      <v-text-field counter label="タイトル（必須）" :rules="titleRules" v-model="title" data-cy="create-title-field"></v-text-field>
      <v-textarea counter label="本文（必須）" :rules="contentRules" v-model="content" data-cy="create-content-field"></v-textarea>
      <v-text-field counter label="選択肢1（必須）" :rules="requiredOptionRules" v-model="option1" data-cy="create-option1-field"></v-text-field>
      <v-text-field counter label="選択肢2（必須）" :rules="requiredOptionRules" v-model="option2" data-cy="create-option2-field"></v-text-field>
      <v-text-field counter label="選択肢3（任意）" :rules="optionRules" v-model="option3" data-cy="create-option3-field"></v-text-field>
      <v-text-field counter label="選択肢4（任意）" :rules="optionRules" v-model="option4" data-cy="create-option4-field"></v-text-field>
      <br>
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
      <p>＊一度作成したアンケートは編集できません。アンケートの内容を変更したい場合、一度アンケートを削除したあとに、もう一度アンケートを作成してください。</p>
      <submit-button
        :error="error"
        :buttonTitle="'確認画面を表示する'"
        @submitForm="confirmationDialog = true"
        @closeDialog="$emit('closeDialog')"
      >
      </submit-button>
    </v-form>

    <!-- アンケート内容確認ダイアログ -->
    <v-dialog v-model="confirmationDialog">
      <v-card data-cy="survey-confirmation-dialog">
        <v-card-title style="justify-content: center;">
          <h2>内容確認</h2>
        </v-card-title>
        <br>
        <v-card-text>
          <br><h3>選択されたジャンル: {{ selectedGenre }}</h3><br>
          <v-text-field counter label="タイトル（必須）" :rules="titleRules" v-model="title" readonly solo data-cy="confirmation-title-field"></v-text-field>
          <v-textarea counter label="本文（必須）" :rules="contentRules" v-model="content" readonly solo data-cy="confirmation-content-field"></v-textarea>
          <v-text-field counter label="選択肢1（必須）" :rules="requiredOptionRules" v-model="option1" readonly solo data-cy="confirmation-option1-field"></v-text-field>
          <v-text-field counter label="選択肢2（必須）" :rules="requiredOptionRules" v-model="option2" readonly solo data-cy="confirmation-option2-field"></v-text-field>
          <v-text-field counter label="選択肢3（任意）" :rules="optionRules" v-model="option3" readonly solo data-cy="confirmation-option3-field"></v-text-field>
          <v-text-field counter label="選択肢4（任意）" :rules="optionRules" v-model="option4" readonly solo data-cy="confirmation-option4-field"></v-text-field>
          <br>
          <v-file-input
            v-model="selectedFile"
            accept="image/jpeg, image/png"
            show-size
            truncate-length="15"
            outlined
            label="ファイルを選択"
            prepend-icon="mdi-image-plus"
            style="width: 500px;"
            disabled
          ></v-file-input>

        </v-card-text>
        <p>＊一度作成したアンケートは編集できません。アンケートの内容を変更したい場合、一度アンケートを削除したあとに、もう一度アンケートを作成してください。</p>
        <submit-button
          :error="error"
          :buttonTitle="'作成する'"
          @submitForm="submitForm"
          @closeDialog="confirmationDialog = false"
        >
        </submit-button>
      </v-card>
    </v-dialog>


  </div>
</template>

<script>
import { VTextField } from "vuetify/lib"
import SubmitButton from "../global/SubmitButton.vue"
import sharedMethods from "../../mixins/sharedMethods"

export default {
  components: {
    VTextField,
    SubmitButton,
  },
  mixins: [sharedMethods],
  data() {
    return {
      titleRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || "").length <= 50 || "最大入力文字数は50文字です",
      ],
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || "").length <= 1000 || "最大入力文字数は1000文字です",
      ],
      requiredOptionRules: [
        value => !!value || "選択肢を入力してください",
        value => (value || "").length <= 50 || "最大入力文字数は50文字です",
      ],
      optionRules: [
        value => (value || "").length <= 50 || "最大入力文字数は50文字です",
      ],
      genres: ["国語", "社会", "数学", "英語", "理科", "参考書", "進路・大学", "その他"],
      selectedGenre: "",
      title: "",
      content: "",
      option1: "",
      option2: "",
      option3: "",
      option4: "",
      confirmationDialog: false,
      selectedFile: null,
      errorMessage: "",
      error: false
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
        image: this.selectedFile
      }

      if(this.option3 !== "") {
        survey.option3 = this.option3
      }

      if(this.option4 !== "") {
        survey.option4 = this.option4
      }
      this.$emit("submitSurvey", survey)
    },
  }
}
</script>

<style>

</style>
