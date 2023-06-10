<template>
  <div>
    <h1>質問を投稿する</h1>
    <v-form>
      <v-col
        class="d-flex"
        cols="12"
        sm="6"
      >
      <v-btn @click="selectSubjectDialog = true">科目を選択する</v-btn>
      </v-col>
      <h3 v-if="subject">選択された科目：{{ subject }}</h3>
      <v-text-field counter label="タイトル" :rules="titleRules" v-model="title"></v-text-field>
      <v-textarea outlined counter label="本文" :rules="contentRules" v-model="content"></v-textarea>
      <v-row>
        <v-col cols="2" class="align-start custom-button-margin">
          <v-btn color="primary" @click="submitForm">投稿する</v-btn>
        </v-col>
        <v-col cols="2" class="align-start">
          <v-btn @click="$emit('closeDialog')">閉じる</v-btn>
        </v-col>
      </v-row>
    </v-form>

    <!-- 科目選択ダイアログ -->
    <v-dialog v-model="selectSubjectDialog" max-width="500px">
      <v-card>
        <v-card-title class="headline">科目選択</v-card-title>
        <v-card-text>
          <v-radio-group v-model="subject">
            <template v-for="category in categories">
              <p :key="category.name">{{ category.name }}</p>
              <v-radio v-for="subcategory in category.subcategories" :key="subcategory" :label="subcategory" :value="subcategory"></v-radio>
            </template>
          </v-radio-group>
        </v-card-text>
        <h3>選択された科目:{{ subject }}</h3>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn @click="selectSubjectDialog = false" color="primary" block>閉じる</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

  </div>
</template>

<script>
import { VTextField, VTextarea } from 'vuetify/lib'

export default {
  components: {
    VTextField,
    VTextarea,
  },
  data() {
    return {
      title: "",
      content: "",
      subject: "",
      titleRules: [
        value => !!value || "タイトルを入力してください",
        value => (value || '').length <= 60 || "最大入力文字数は60文字です",
      ],
      contentRules: [
        value => !!value || "本文を入力してください",
        value => (value || '').length <= 1000 || "最大入力文字数は1000文字です",
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
          subcategories: ["過去問", "小論文", "その他"]
        },
      ],
    }
  },
  methods: {
    submitForm() {
      this.$emit('submitSubjectQuestion', { title: this.title, content: this.content, subject: this.subject })
    },
  }
}
</script>

<style>

</style>
