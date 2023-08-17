<template>
  <v-row class="d-flex justify-space-between">
    <v-col cols="6" class="d-flex justify-start">
      <v-btn @click="previousContent" x-large><v-icon>mdi-arrow-left-bold</v-icon>前の{{ content }}</v-btn>
    </v-col>
    <v-col cols="6" class="d-flex justify-end">
      <v-btn @click="nextContent" x-large>次の{{ content }}<v-icon>mdi-arrow-right-bold</v-icon></v-btn>
    </v-col>
  </v-row>

</template>

<script>
export default {
  props: {
    content: String,
  },
  methods: {
    previousContent() {
      this.$emit("previousContent")
    },
    nextContent() {
      this.$emit("nextContent")
    }
  }
}
</script>

<style>

</style>
