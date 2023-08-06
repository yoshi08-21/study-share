<template>
  <div>
    <v-progress-linear
      :value="option1Percentage"
      color="primary"
      height="30"
      :rounded="true"
    >
      選択肢1 => {{ selectedOption1Count }}件 ({{ option1Percentage.toFixed(0) }}%)
    </v-progress-linear>
    <v-progress-linear
      :value="option2Percentage"
      color="teal"
      height="30"
      :rounded="true"
    >
      選択肢2 => {{ selectedOption2Count }}件 ({{ option2Percentage.toFixed(0) }}%)
    </v-progress-linear>
    <template v-if="survey.option3">
      <v-progress-linear
        :value="option3Percentage"
        color="lime"
        height="30"
        :rounded="true"
      >
        選択肢3 => {{ selectedOption3Count }}件 ({{ option3Percentage.toFixed(0) }}%)
      </v-progress-linear>
    </template>
    <template v-if="survey.option4">
      <v-progress-linear
        :value="option4Percentage"
        color="blue-grey"
        height="30"
        :rounded="true"
      >
        選択肢4 => {{ selectedOption4Count }}件 ({{ option4Percentage.toFixed(0) }}%)
      </v-progress-linear>
    </template>
  </div>


</template>

<script>
export default {
  props: {
    survey: Object,
    selectedOption1Count: Number,
    selectedOption2Count: Number,
    selectedOption3Count: Number,
    selectedOption4Count: Number,
    option1Percentage: Number,
    option2Percentage: Number,
    option3Percentage: Number,
    option4Percentage: Number,

  },
  data() {
    return {

    }
  }
}
</script>

<style>

</style>
