<template>
  <div>
    <v-form>
      <v-col
        class="d-flex"
        cols="12"
        sm="6"
      >
        <v-btn @click="selectSubjectDialog = true">科目を選択する(必須)</v-btn>
      </v-col>
      <h3 v-if="subject">選択された科目：{{ subject }}</h3>
      <br><br>
      <v-file-input
        v-model="selectedFile"
        accept="image/jpeg, image/png"
        show-size
        truncate-length="15"
        outlined
        label="参考書の画像を選択"
        prepend-icon="mdi-image-plus"
        style="width: 500px;"
        @change="checkFileSize"
        data-cy="select-book-image"
      ></v-file-input>
      *画像は「.jpeg」「.jpg」「.png」のみ登録できます
      <br>
      *登録できる画像のファイルサイズは3MBまでです

      <br><br>
      <v-text-field counter label="タイトル（必須）" :rules="titleRules" v-model="name" data-cy="create-name-field"></v-text-field>
      <v-text-field counter label="著者（必須）" :rules="authorRules" v-model="author" data-cy="create-author-field"></v-text-field>
      <v-text-field counter label="出版社" :rules="publisherRules" v-model="publisher" data-cy="create-publisher-field"></v-text-field>
      <v-textarea counter outlined label="参考書の説明" :rules="descriptionRules" v-model="description" data-cy="create-description-field"></v-textarea>
      <template v-if="errorMessage">
        <v-alert type="error" dense text border="left">
          {{ errorMessage }}
        </v-alert>
      </template>

      <submit-button
        :error="error"
        :buttonTitle="'登録する'"
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
          <v-radio-group v-model="subject" data-cy="select-subject-group">
            <template v-for="category in categories">
              <p :key="category.name">{{ category.name }}</p>
              <v-radio v-for="subcategory in category.subcategories" :key="subcategory" :label="subcategory" :value="subcategory"></v-radio>
            </template>
          </v-radio-group>
        </v-card-text>
        <h3>選択された科目:{{ subject }}</h3>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn @click="selectSubjectDialog = false" color="primary" block data-cy="close-select-subject-dialog">閉じる</v-btn>
        </v-card-actions>
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
      name: "",
      author: "",
      publisher: "",
      subject: "",
      description: "",
      keepedSubject: "",
      titleRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || "").length <= 50 || "最大入力文字数は50文字です",
      ],
      authorRules: [
        value => !!value || "著者を入力してください",
        value => (value || "").length <= 25 || "最大入力文字数は25文字です",
      ],
      publisherRules: [
        value => (value || "").length <= 25 || "最大入力文字数は25文字です",
      ],
      descriptionRules: [
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
      error: false,
    }
  },
  methods: {
    submitForm() {
      this.$emit("submitBook", { name: this.name, author: this.author, publisher: this.publisher, subject: this.subject, image: this.selectedFile, description: this.description })
    },
  }
}
</script>

<style>

</style>
