<template>
  <v-row class="d-flex justify-space-around">
    <v-col cols="6" class="d-flex justify-center">
      <template v-if="error === true">
        <v-btn
          color="primary"
          disabled
          @click="submitForm"
          width="400"
          large
        >
        {{ buttonTitle }}
      </v-btn>
      </template>
      <template v-else>
        <v-btn
          @click="submitForm"
          color="primary"
          width="400"
          large
        >
        {{ buttonTitle }}
      </v-btn>
      </template>
    </v-col>
    <v-col cols="6" class="d-flex justify-center">
      <v-btn
        @click="$emit('closeDialog')"
        large
        width="400"
      >
      閉じる
    </v-btn>
    </v-col>
  </v-row>

</template>

<script>
export default {
  props: {
    error: Boolean,
    buttonTitle: String
  },
  methods: {
    submitForm() {
      this.$emit("submitForm")
    },
  }
}
</script>

<style>

</style>
