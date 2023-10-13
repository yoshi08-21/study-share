<template>
  <div style="text-align: center;">
    <h2>ユーザー登録が完了しました！</h2>
    <br>
    <p>下記のリンクからログインしてください</p>
    <v-btn to="/auth/login" width="400">ログイン</v-btn>

    <br>
    <v-snackbar v-model="snackbar" :timeout="3000" :color="snackbarColor">{{ flashMessage }}</v-snackbar>
  </div>
</template>

<script>

import flashMessage from '../../mixins/flashMessage'



export default {
  mixins: [flashMessage],
}
</script>

<style>

</style>
