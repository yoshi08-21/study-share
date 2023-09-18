<template>
  <div>

    <div style="margin-bottom: 10px;">
      <h3>質問情報</h3>
    </div>
    <v-card
      elevation="8"
      data-cy="subject-question-information"
    >
      <v-row>
        <v-col cols="2" class="mt-8">
          <div @click="goToUser(subjectQuestionUser)" style="cursor: pointer;">
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
              <v-avatar size="100">
                <v-img :src="subjectQuestionUser.image" alt="画像" contain></v-img>
              </v-avatar>
            </v-col>
          </v-row>
          <v-row>
            <v-col class="d-flex justify-center align-center text-center">
                <span style="text-decoration: underline;">{{ $truncate(subjectQuestionUser.name, 10) }}</span>
              </v-col>
            </v-row>
          </div>
        </v-col>
        <v-col cols="9" class="mt-n2">
          <v-card-title>
            <nuxt-link :to="`/subjectQuestions/${subjectQuestion.id}`">{{ subjectQuestion.title }}</nuxt-link>
          </v-card-title>
          <v-card-subtitle style="margin-top: 5px;">
            <h3>科目: {{ subjectQuestion.subject }}</h3>
          </v-card-subtitle>
          <v-card-text>
            <v-textarea
              :value="subjectQuestion.content"
              readonly
              filled
              rounded
              dense
              no-resize
              rows="4"
              style="height: 150px;"
            >
            </v-textarea>

          </v-card-text>
          <v-card-actions>

            <v-row class="d-flex align-center justify-center">
              <v-col cols="4" data-cy="subject-question-favorite-section">
                <v-icon>mdi-heart-multiple</v-icon>
                いいね! ({{ subjectQuestion.favorite_subject_questions_count }})
              </v-col>
              <v-col cols="4" data-cy="subject-question-reply-section">
                <v-icon>mdi-comment-text-outline</v-icon>
                返信: {{ subjectQuestion.subject_question_replies_count }}件
              </v-col>
            </v-row>
            <p>
            </p>
          </v-card-actions>
        </v-col>
      </v-row>
    </v-card>


    <br><br><br>
    <div class="d-flex justify-space-between" style="margin-top: 50px; margin-bottom: 10px;">
      <h2>返信詳細(科目別)</h2>
      <nuxt-link :to="`/subjectQuestions/${subjectQuestion.id}`">質問詳細に戻る</nuxt-link>
    </div>
    <v-card
      elevation="8"
      style="padding-bottom: 1px;"
      data-cy="subject-question-reply-detail"
    >
      <v-row>
        <v-col cols="2" class="mt-8">
          <div @click="goToUser(subjectQuestionReplyUser)" style="cursor: pointer;">
            <v-row>
              <v-col class="d-flex justify-center align-center text-center">
                <v-avatar size="100">
                  <v-img :src="subjectQuestionReplyUser.image" alt="画像" contain></v-img>
                </v-avatar>
              </v-col>
            </v-row>
            <v-row>
              <v-col class="d-flex justify-center align-center text-center">
                  <span style="text-decoration: underline;">{{ $truncate(subjectQuestionReplyUser.name, 10) }}</span>
              </v-col>
            </v-row>
          </div>
        </v-col>
        <v-col cols="8" class="mt-n2">

          <v-card-title>
            <v-textarea
              :value="subjectQuestionReply.content"
              readonly
              outlined
              rounded
              dense
              auto-grow
            >
            </v-textarea>
          </v-card-title>

          <template v-if="subjectQuestionReply.image">
            <v-row>
              <v-col class="d-flex justify-center">
                <v-img
                  @click="showFullImage = true"
                  :src="subjectQuestionReply.image"
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
              <v-col cols="4">
                <favorite-button
                  :currentUser="currentUser"
                  :user="subjectQuestionReplyUser"
                  :isFavorite="isFavorite"
                  :favoriteCount="subjectQuestionReply.favorite_subject_question_replies_count"
                  @addToFavorite="addToFavorite"
                  @removeFromFavorite="removeFromFavorite"
                ></favorite-button>
              </v-col>
              <v-col cols="4">
                <v-icon>mdi-calendar-clock</v-icon>
                {{ subjectQuestionReply.created_at }}
              </v-col>
            </v-row>
          </v-card-actions>

        </v-col>
        <v-col cols="2" class="d-flex flex-column" style="padding: 20px;">
          <template v-if="currentUser && subjectQuestionReplyUser.id == currentUser.id">
            <v-btn @click="dialog=true" style="margin-bottom: 10px;">編集する</v-btn>
            <v-btn @click="showDeleteConfirmation=true">削除する</v-btn>
          </template>
        </v-col>
      </v-row>
    </v-card>

    <br><br>
    <content-navigator
      :content="'返信'"
      @previousContent="previousReply"
      @nextContent="nextReply"
    >
    </content-navigator>


    <!-- 返信編集ダイアログ -->
    <v-dialog v-model="dialog">
      <v-card>
        <v-card-title>
          返信を編集する
        </v-card-title>
        <v-card-text>
          <edit-reply
            :content="subjectQuestionReply.content"
            @submitReply="editSubjectQuestionReply"
            @closeDialog="dialog = false"
          ></edit-reply>
        </v-card-text>
      </v-card>
    </v-dialog>

    <!-- 質問削除の確認ダイアログ -->
    <delete-confirmation-dialog
      :showDeleteConfirmation="showDeleteConfirmation"
      :contentTitle="'返信'"
      @deleteContent="deleteSubjectQuestionReply"
      @closeDeleteConfirmation="showDeleteConfirmation = false"
    >
    </delete-confirmation-dialog>

    <!-- 大きいサイズの画像表示用のダイアログ -->
    <show-full-image-dialog
      :showFullImage="showFullImage"
      :image="subjectQuestionReply.image"
      @closeShowFullImage="showFullImage = false"
    >
    </show-full-image-dialog>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>

  </div>
</template>

<script>

import EditReply from '../../../../components/replies/EditReply.vue'
import ContentNavigator from '../../../../components/global/ContentNavigator.vue'
import DeleteConfirmationDialog from '../../../../components/global/DeleteConfirmationDialog.vue'
import userComputed from '../../../../mixins/userComputed'
import flashMessage from '../../../../mixins/flashMessage'
import navigationMethods from '../../../../mixins/navigationMethods'

import axios from "@/plugins/axios"


export default {
  components: { EditReply, ContentNavigator, DeleteConfirmationDialog },
  mixins: [userComputed, flashMessage, navigationMethods],
  async asyncData({ params, store }) {
    try {
      let currentUserId = null
      const currentUser = store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

      const [subjectQuestionReplyResponse, subjectQuestionRepliesResponse] = await Promise.all([
        axios.get(`/subject_questions/${params.subjectQuestion_id}/subject_question_replies/${params.id}`, {
          params: {
            current_user_id: currentUserId
          }
        }),
        axios.get(`/subject_questions/${params.subjectQuestion_id}/subject_question_replies`)
      ])

      console.log(subjectQuestionReplyResponse.data)
      console.log(subjectQuestionRepliesResponse.data)
      return {
        subjectQuestion: subjectQuestionReplyResponse.data.subject_question,
        subjectQuestionUser: subjectQuestionReplyResponse.data.subject_question_user,
        subjectQuestionReply: subjectQuestionReplyResponse.data.subject_question_reply,
        subjectQuestionReplyUser: subjectQuestionReplyResponse.data.subject_question_reply_user,
        subjectQuestionReplies: subjectQuestionRepliesResponse.data,
        params
      };
    } catch(error) {
      console.log(error)
      throw error
    }
  },
  data() {
    return {
      dialog: false,
      showDeleteConfirmation: false,
      isFavorite: false,
      favoriteSubjectQuestionReplyId: "",
      showFullImage: false,
    }
  },
  async created() {
    try {
      let currentUserId = ""
      const currentUser = this.$store.getters["auth/getCurrentUser"]
      if (currentUser && currentUser.id) {
        currentUserId = currentUser.id
      }

        const response = await axios.get("subject_question_replies/is_favorite", {
        params: {
          current_user_id: currentUserId,
          subject_question_reply_id: this.$route.params.id
        }
      })
      console.log(response)
      this.isFavorite = response.data.is_favorite
      this.favoriteSubjectQuestionReplyId = response.data.favorite_reply_id
    } catch(error) {
      console.log(error)
    }
  },
  methods: {
    redirectToSubjectQuestion() {
      this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}` })
    },
    async editSubjectQuestionReply(data) {
      const formData = new FormData()

      formData.append("current_user_id", this.currentUser.id);
      formData.append("subject_question_reply[content]", data.content);
      if (data.image) {
          formData.append("subject_question_reply[image]", data.image);
      }

      try {
        const response = await axios.patch(`/subject_questions/${this.subjectQuestion.id}/subject_question_replies/${this.subjectQuestionReply.id}`, formData)
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "返信の編集が完了しました"
        this.subjectQuestionReply.content = response.data.subject_question_reply.content
        if (response.data.image_url) {
          this.subjectQuestionReply.image = response.data.image_url
        }
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を編集できませんでした"
      }
      this.dialog = false
    },
    async deleteSubjectQuestionReply() {
      try {
        const response = await axios.delete(`/subject_questions/${this.subjectQuestion.id}/subject_question_replies/${this.subjectQuestionReply.id}`, {
          params: { current_user_id: this.currentUser.id }
        })
        console.log(response)
        this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}`, query: { message: '返信を削除しました' } })
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "返信を削除できませんでした"
        this.dialog = false
      }
    },
    async addToFavorite() {
      try {
        const response = await axios.post(`/subject_question_replies/${this.subjectQuestionReply.id}/favorite_subject_question_replies`, {
          current_user_id: this.currentUser.id
        })
        console.log(response)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね!しました"
        this.isFavorite = true
        this.favoriteSubjectQuestionReplyId = response.data.id
        this.subjectQuestionReply.favorite_subject_question_replies_count += 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "すでにいいね!されています"
      }
    },
    async removeFromFavorite() {
      try {
        const response = await axios.delete(`/subject_question_replies/${this.subjectQuestionReply.id}/favorite_subject_question_replies/${this.favoriteSubjectQuestionReplyId}`, {
          params: {
            current_user_id: this.currentUser.id
          }
        })
        console.log(response.data)
        this.snackbarColor = "primary"
        this.snackbar = true
        this.flashMessage = "いいね!を削除しました"
        this.isFavorite = !this.isFavorite
        this.favoriteReplyId = null
        this.subjectQuestionReply.favorite_subject_question_replies_count -= 1
      } catch(error) {
        console.log(error)
        this.snackbarColor = "red accent-2"
        this.snackbar = true
        this.flashMessage = "いいね!されていません"
      }
    },
    nextReply() {
      const index = this.subjectQuestionReplies.findIndex(item => item.id === this.subjectQuestionReply.id)
      const nextIndex = index + 1
      const nextSubjectQuestionReply = this.subjectQuestionReplies[nextIndex]
      const lastItem = this.subjectQuestionReplies[this.subjectQuestionReplies.length - 1]
      if(this.subjectQuestionReply.id !== lastItem.id) {
        this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}/subjectQuestionReplies/${nextSubjectQuestionReply.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最後の返信です"
      }
    },
    previousReply() {
      const index = this.subjectQuestionReplies.findIndex(item => item.id === this.subjectQuestionReply.id)
      const previousIndex = index - 1
      const previousSubjectQuestionReply = this.subjectQuestionReplies[previousIndex]
      const firstItem = this.subjectQuestionReplies[0]
      if(this.subjectQuestionReply.id !== firstItem.id) {
        this.$router.push({ path: `/subjectQuestions/${this.subjectQuestion.id}/subjectQuestionReplies/${previousSubjectQuestionReply.id}` })
      } else {
        this.snackbar = true
        this.snackbarColor = "blue-grey"
        this.flashMessage = "最初の返信です"
      }
    }
  }
}
</script>

<style>

</style>
