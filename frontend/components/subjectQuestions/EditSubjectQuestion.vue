<template>
  <div>
    <br>
    <v-form>
      <br>
      <v-col
        class="d-flex"
        cols="12"
        sm="6"
      >
      <v-btn @click="selectSubjectDialog = true">科目を選択する(必須)</v-btn>
      </v-col>
      <h3 v-if="editedSubject">選択された科目：{{ editedSubject }}</h3>
      <br>
      <v-text-field counter label="タイトル" :rules="titleRules" v-model="editedTitle" data-cy="edit-title-field"></v-text-field>
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

    <!-- 科目選択ダイアログ -->
    <v-dialog v-model="selectSubjectDialog" max-width="500px">
      <v-card>
        <v-card-title class="headline">科目選択</v-card-title>
        <v-card-text>
          <v-radio-group v-model="editedSubject" data-cy="select-subject-group">
            <template v-for="category in categories">
              <p :key="category.name">{{ category.name }}</p>
              <v-radio v-for="subcategory in category.subcategories" :key="subcategory" :label="subcategory" :value="subcategory"></v-radio>
            </template>
          </v-radio-group>
        </v-card-text>
        <h3>選択された科目:{{ editedSubject }}</h3>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn @click="selectSubjectDialog = false" color="primary" block data-cy="close-select-subject-dialog">閉じる</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>


  </div>
</template>

<script>
import { VTextField, VTextarea } from "vuetify/lib"
import SubmitButton from "../global/SubmitButton.vue"
import sharedMethods from "../../mixins/sharedMethods"

export default {
  props: {
    title: String,
    content: String,
    subject: String
  },
  components: {
    VTextField,
    VTextarea,
    SubmitButton,
  },
  mixins: [sharedMethods],
  data() {
    return {
      editedTitle: this.title,
      editedContent: this.content,
      editedSubject: this.subject,
      titleRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || "").length <= 60 || "最大入力文字数は60文字です",
      ],
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || "").length <= 1000 || "最大入力文字数は1000文字です",
      ],
      selectSubjectDialog: false,
      categories: [
        {
          name: "国語",
          subcategories: ["現代文", "古文", "漢文"]
        },
        {
          name: "社会",
          subcategories: ["日本史", "世界史", "地理", "倫理・政治経済"]
        },
        {
          name: "数学",
          subcategories: ["数学I・A", "数学Ⅱ・B", "数学Ⅲ・C"]
        },
        {
          name: "英語",
          subcategories: ["英文法", "英文読解", "英作文", "英単語", "リスニング"]
        },
        {
          name: "理科",
          subcategories: ["物理", "生物", "化学", "地学"]
        },
        {
          name: "その他",
          subcategories: ["過去問", "小論文", "その他科目"]
        },
      ],
      selectedFile: null,
      errorMessage: "",
      error: false
    }
  },
  methods: {
    submitForm() {
      this.$emit("submitSubjectQuestion", { title: this.editedTitle, content: this.editedContent, subject: this.editedSubject, image:this.selectedFile })
    },
  }
}
</script>

<style>

</style>
