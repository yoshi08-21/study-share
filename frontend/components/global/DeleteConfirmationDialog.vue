<template>
  <v-dialog
    v-model="showDeleteConfirmation"
    width="800"
  >
    <v-card height="300">
      <v-row class="d-flex justify-center">
        <v-col>
          <v-card-title style="height: 120px;">
            <v-alert type="error" dense text prominent border="left" width="100%">
              削除した{{ contentTitle }}は復元できません!
            </v-alert>
          </v-card-title>
          <v-card-text style="text-align: center; height: 90px;">
            <h1>
              {{ contentTitle }}を削除しますか？
            </h1>
          </v-card-text>
          <v-card-actions>
            <v-row>
              <v-col cols="6" class="d-flex justify-center">
                <v-btn
                @click="deleteContent"
                large
                width="300"
                color="error"
                dark
                >
                  削除する
                </v-btn>
              </v-col>
              <v-col cols="6" class="d-flex justify-center">
                <v-btn
                @click="closeDeleteConfirmation"
                large
                width="300"

                >
                  戻る
                </v-btn>
              </v-col>
            </v-row>
          </v-card-actions>
        </v-col>
      </v-row>
    </v-card>
  </v-dialog>

</template>

<script>
export default {
  props: {
    showDeleteConfirmation: Boolean,
    contentTitle: String,
  },
  methods: {
    deleteContent() {
      this.$emit("deleteContent")
    },
    closeDeleteConfirmation() {
      this.$emit("closeDeleteConfirmation")
    }
  }
}
</script>

<style>

</style>
