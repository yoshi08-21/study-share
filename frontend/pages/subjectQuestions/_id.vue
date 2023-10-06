<template>
  <div>
    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>質問詳細(科目別)</h2>
      <nuxt-link :to="`/subjectQuestions/allSubjectQuestions`">質問一覧に戻る</nuxt-link>
    </div>
    <v-card
      elevation="8"
      style="padding-bottom: 1px;"
      data-cy="subject-question-detail"
    >
      <v-row>
        <v-col cols="2" class="mt-8">
          <div @click="goToUser(user)" style="cursor: pointer;">
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
              <v-avatar size="100">
                <v-img :src="user.image" alt="画像" contain></v-img>
              </v-avatar>
            </v-col>
          </v-row>
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
                <span style="text-decoration: underline;">{{ $truncate(user.name, 10) }}</span>
              </v-col>
            </v-row>
          </div>
        </v-col>
        <v-col cols="8" class="mt-n2">

          <v-card-title>
            <h3>{{ subjectQuestion.title }}</h3>
          </v-card-title>

          <v-card-subtitle style="margin-top: 10px;">
            <h3>科目: {{ subjectQuestion.subject }}</h3>
          </v-card-subtitle>

          <v-card-text>
            <v-textarea
              :value="subjectQuestion.content"
              readonly
              outlined
              rounded
              dense
              auto-grow
            >
            </v-textarea>
          </v-card-text>

          <template v-if="subjectQuestion.image">
            <v-row>
              <v-col class="d-flex justify-center">
                <v-img
                  @click="showFullImage = true"
                  :src="subjectQuestion.image"
                  alt="画像"
                  contain
                  max-height="250"
                  max-width="250"
                  style="cursor: pointer;"
                ></v-img>
              </v-col>
            </v-row>
            <v-row>
              <v-col class="d-flex justify-center">
                *画像をクリックすると拡大できます
              </v-col>
            </v-row>
          </template>

          <br>
          <v-card-actions>
            <v-row class="d-flex align-center justify-center">
              <v-col cols="4" data-cy="subject-question-reply-section">
                <v-icon>mdi-comment-text-outline</v-icon>
                  返信: {{ subjectQuestion.subject_question_replies_count }}件
              </v-col>
              <v-col cols="4">
                <favorite-button
                  :currentUser="currentUser"
                  :user="user"
                  :isFavorite="isFavorite"
                  :favoriteCount="subjectQuestion.favorite_subject_questions_count"
                  @addToFavorite="addToFavorite"
                  @removeFromFavorite="removeFromFavorite"
                ></favorite-button>
              </v-col>
              <v-col cols="4">
                <v-icon>mdi-calendar-clock</v-icon>
                {{ subjectQuestion.created_at }}
              </v-col>
            </v-row>
          </v-card-actions>

        </v-col>
        <v-col cols="2" class="d-flex flex-column" style="padding: 20px;">
          <template v-if="currentUser && user.id == currentUser.id">
            <v-btn @click="dialog=true" style="margin-bottom: 10px;">編集する</v-btn>
            <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
          </template>
        </v-col>
      </v-row>
    </v-card>

    <br><br>
    <content-navigator
      :content="`${subjectQuestion.subject}の質問`"
      @previousContent="previousQuestion"
      @nextContent="nextQuestion"
    >
    </content-navigator>

    <br><br>
    <hr>

    <br><br><br><br>
    <v-card height="100px">
      <v-row style="height: 100%;">
        <v-col class="d-flex justify-center align-center">
          <v-btn
            @click="openSubjectQuestionReplyDialog"
            x-large
            rounded
            color="success"
            width="600px"
          >
          返信を投稿する
        </v-btn>
        </v-col>
      </v-row>
    </v-card>

    <br><br>
    <template v-if="subjectQuestionReplies.length !== 0">
      <v-row>
        <v-col class="d-flex justify-center">
          <h2>返信一覧</h2>
        </v-col>
      </v-row>
      <br>
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
      <br>
      <subject-question-subject-question-replies :subjectQuestionReplies="subjectQuestionReplyChunk"></subject-question-subject-question-replies>
      <br>
      <v-pagination v-model="page" :length="totalPages"></v-pagination>
    </template>
    <template v-else>
      <v-row>
        <v-col class="d-flex justify-center">
          <h2>返信一覧</h2>
        </v-col>
      </v-row>
      <v-row>
        <v-col class="d-flex justify-center">
          <v-alert
            type="info"
          >
          返信は投稿されていません
          </v-alert>
        </v-col>
      </v-row>
    </template>


    <!-- 新規返信投稿ダイアログ -->
    <v-dialog v-model="subjectQuestionReplyDialog">
      <v-card>
        <v-card-title style="justify-content: center;">
          <h2>返信を投稿する</h2>
        </v-card-title>
        <v-card-text>
          <reply-form @submitReply="submitSubjectQuestionReply" @closeDialog="subjectQuestionReplyDialog = false"></reply-form>
        </v-card-text>
      </v-card>
    </v-dialog>

    <!-- 質問編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title style="justify-content: center;">
          <h2>質問を編集する</h2>
        </v-card-title>
        <v-card-text>
          <edit-subject-question
            :title="subjectQuestion.title"
            :content="subjectQuestion.content"
            :subject="subjectQuestion.subject"
            @submitSubjectQuestion="editSubjectQuestion"
            @closeDialog="dialog = false"
          ></edit-subject-question>
        </v-card-text>
      </v-card>
    </v-dialog>

    <!-- 質問削除の確認ダイアログ -->
    <delete-confirmation-dialog
      :showDeleteConfirmation="showDeleteConfirmation"
      :contentTitle="'質問'"
      @deleteContent="deleteSubjectQuestion"
      @closeDeleteConfirmation="showDeleteConfirmation = false"
    >
    </delete-confirmation-dialog>

    <!-- 大きいサイズの画像表示用のダイアログ -->
    <show-full-image-dialog
      :showFullImage="showFullImage"
      :image="subjectQuestion.image"
      @closeShowFullImage="showFullImage = false"
    >
    </show-full-image-dialog>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import EditSubjectQuestion from '../../components/subjectQuestions/EditSubjectQuestion.vue'
import ReplyForm from '../../components/replies/ReplyForm.vue'
import FavoriteButton from '../../components/global/FavoriteButton.vue'
import ContentNavigator from '../../components/global/ContentNavigator.vue'
import SubjectQuestionSubjectQuestionReplies from '../../components/subjectQuestionReplies/SubjectQuestionSubjectQuestionReplies.vue'
import DeleteConfirmationDialog from '../../components/global/DeleteConfirmationDialog.vue'
import ShowFullImageDialog from '../../components/global/ShowFullImageDialog.vue'
import userComputed from '../../mixins/userComputed'
import flashMessage from '../../mixins/flashMessage'
import navigationMethods from '../../mixins/navigationMethods'

import axios from "@/plugins/axios"

export default {
  components: { EditSubjectQuestion, ReplyForm, FavoriteButton, ContentNavigator, SubjectQuestionSubjectQuestionReplies, DeleteConfirmationDialog, ShowFullImageDialog },
  mixins: [userComputed, flashMessage, navigationMethods],
  async asyncData({ params, store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [subjectQuestionResponse, subjectQuestionsResponse, subjectQuestionRepliesResponse] = await Promise.all([
        axios.get(`subject_questions/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get("/subject_questions/questions_to_specific_subject", {
          params: {
            subject_question_id: params.id
          }
        }),
        axios.get(`subject_questions/${params.id}/subject_question_replies`)
      ])
      return {
        subjectQuestion: subjectQuestionResponse.data.subject_question,
        user: subjectQuestionResponse.data.subject_question_user,
        subjectQuestions: subjectQuestionsResponse.data,
        subjectQuestionReplies: subjectQuestionRepliesResponse.data,
        params
      };
    } catch(error) {
      console.error("エラーが発生しました:", error)
    }
  },
  data() {
    return {
      dialog: false,
      showDeleteConfirmation: false,
      isFavorite: false,
      favoriteSubjectQuestionId: "",
      subjectQuestionReplyDialog: false,
      perPage: 10,
      page: 1,
      showFullImage: false,

    }
  },
  computed: {
    subjectQuestionReplyChunk() {
      const start = (this.page - 1) * this.perPage
      const end = start + this.perPage
      return this.subjectQuestionReplies.slice(start, end)
    },
    totalPages() {
      return Math.ceil(this.subjectQuestionReplies.length / this.perPage);
    },
  },
  async created() {
    try {
      let currentUserId = ""
      const currentUser = this.$store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const response = await axios.get("subject_questions/is_favorite", {
        params: {
          current_user_id: currentUserId,
          subject_question_id: this.$route.params.id
        }
      })
      this.isFavorite = response.data.is_favorite
      this.favoriteSubjectQuestionId = response.data.favorite_subject_question_id
    } catch(error) {
      console.error("エラーが発生しました:", error)
    }
  },
  methods: {
    async editSubjectQuestion(data) {
      const formData = new FormData()

      formData.append("current_user_id", this.currentUser.id);
      formData.append("subject_question[title]", data.title);
      formData.append("subject_question[content]", data.content);
      formData.append("subject_question[subject]", data.subject);
      if (data.image) {
          formData.append("subject_question[image]", data.image);
      }

      try {
        const response = await axios.patch(`/subject_questions/${this.subjectQuestion.id}`, formData)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "質問の編集が完了しました"
        this.subjectQuestion.title = response.data.subject_question.title
        this.subjectQuestion.content = response.data.subject_question.content
        this.subjectQuestion.subject = response.data.subject_question.subject
        if (response.data.image_url) {
          this.subjectQuestion.image = response.data.image_url
        }
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を編集できませんでした"
      }
      this.dialog = false
    },
    async deleteSubjectQuestion() {
      try {
        await axios.delete(`/subject_questions/${this.subjectQuestion.id}`, {
          params: {
            current_user_id: this.currentUser.id
          }
        })
        this.$router.push({ path: `/subjectQuestions/allSubjectQuestions`, query: { message: '質問を削除しました' } })
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "質問を削除できませんでした"
        this.dialog = false
      }
    },
    async addToFavorite() {
      try {
        const response = await axios.post(`/subject_questions/${this.subjectQuestion.id}/favorite_subject_questions`, {
          current_user_id: this.currentUser.id
        })
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね!しました"
        this.isFavorite = true
        this.favoriteSubjectQuestionId = response.data.id
        this.subjectQuestion.favorite_subject_questions_count +=1
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね!されています"
      }
    },
    async removeFromFavorite() {
      try {
        await axios.delete(`/subject_questions/${this.subjectQuestion.id}/favorite_subject_questions/${this.favoriteSubjectQuestionId}`, {
          params: {
            current_user_id: this.currentUser.id
          }
        })
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね!を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteSubjectQuestionId = null
        this.subjectQuestion.favorite_subject_questions_count -=1
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね!されていません"
      }
    },
    openSubjectQuestionReplyDialog() {
      if(this.currentUser) {
        this.subjectQuestionReplyDialog = true
      } else {
        this.$router.push({ path: "/auth/login", query: { message: "ログインが必要です" } })
      }
    },
    async submitSubjectQuestionReply(data) {
      const formData = new FormData()

      formData.append("current_user_id", this.currentUser.id);
      formData.append("subject_question_reply[content]", data.content);
      if (data.image) {
          formData.append("subject_question_reply[image]", data.image);
      }

      try {
        const response = await axios.post(`/subject_questions/${this.subjectQuestion.id}/subject_question_replies`, formData)
        this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}/subjectQuestionReplies/${response.data.id}`, query: { message: '返信の投稿が完了しました' } })
      } catch(error) {
        console.error("エラーが発生しました:", error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を投稿できませんでした"
      }
      this.subjectQuestionReplyDialog = false
    },
    nextQuestion() {
      const index = this.subjectQuestions.findIndex(item => item.id === this.subjectQuestion.id)
      const nextIndex = index + 1
      const nextSubjectQuestion = this.subjectQuestions[nextIndex]
      const lastItem = this.subjectQuestions[this.subjectQuestions.length - 1]
      if(this.subjectQuestion.id !== lastItem.id) {
        this.$router.push({ path: `/subjectQuestions/${nextSubjectQuestion.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最後の質問です"
      }
    },
    previousQuestion() {
      const index = this.subjectQuestions.findIndex(item => item.id === this.subjectQuestion.id)
      const previousIndex = index - 1
      const previousSubjectQuestion = this.subjectQuestions[previousIndex]
      const firstItem = this.subjectQuestions[0]
      if(this.subjectQuestion.id !== firstItem.id) {
        this.$router.push({ path: `/subjectQuestions/${previousSubjectQuestion.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最初の質問です"
      }
    }
  },
}
</script>
