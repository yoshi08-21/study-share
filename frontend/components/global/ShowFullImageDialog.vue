<template>
  <v-dialog v-model="localShowFullImage">
    <v-card
      max-height="800px"
      style="padding: 10px;"
    >
      <v-row>
        <v-col cols="6" class="d-flex justify-start">
          <v-card-title>拡大画像</v-card-title>
        </v-col>
        <v-col cols="6" class="d-flex justify-end align-center">
          <!-- 親コンポーネントから渡されるshowFullImageの変更を検知してダイアログを表示するため、
            localShowFullImageを直接変更せずに$emitで親コンポーネントの値を変更する -->
          <v-btn @click="$emit('closeShowFullImage')">閉じる</v-btn>
        </v-col>
      </v-row>
      <hr>
      <v-row style="margin-top: 10px; margin-bottom: 5px;">
        <v-col class="d-flex justify-center">
          <v-img
            :src="image"
            max-height="500"
            max-width="500"
            contain
          ></v-img>
        </v-col>
      </v-row>
      <v-row>
        <v-col class="d-flex justify-center">
          <v-btn @click="$emit('closeShowFullImage')">閉じる</v-btn>
        </v-col>
      </v-row>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  props: {
    showFullImage: Boolean,
    image: String
  },
  data() {
    return {
      localShowFullImage: this.showFullImage
    }
  },
  watch: {
    showFullImage(newVal) {
      this.localShowFullImage = newVal;
    },
  },

}
</script>

<style>

</style>
