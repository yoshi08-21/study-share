<template>
  <div>
    <v-flex mb-5 v-for="(survey, index) in surveys" :key="'survey_' + index">
      <v-row>
        <v-col cols="10">
          <v-card :to="`/surveys/${survey.id}`">
            <v-row>
              <v-col cols="10">
                <v-card-title>
                  タイトル: {{ survey.title }}
                </v-card-title>
                <v-card-text>
                  <p>{{ survey.content }}</p>
                </v-card-text>
                <v-card-actions>
                  by: {{ survey.user.name }}
                </v-card-actions>
                <p>
                  回答数: {{ survey.survey_answers_count }}
                  いいね!: {{ survey.favorite_surveys_count }}
                </p>
                <template v-if="survey.status === false">
                  <p>ステータス: 回答受付中</p>
                </template>
                <template v-else>
                  <p>ステータス: 締切済み</p>
                </template>
              </v-col>
            </v-row>
          </v-card>
        </v-col>
      </v-row>
    </v-flex>
  </div>
</template>

<script>
export default {
  props: {
    surveys: [],
  }
}
</script>

<style>

</style>
