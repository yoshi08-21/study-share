<template>
  <div style="text-align: center;">
    <h2>エラーページ</h2>
    <p>存在しないページです</p>
    <br>
    <v-btn  @click="redirectToTopPage" block height="50">トップページに戻る</v-btn>
  </div>
</template>

<script>
export default {
  methods: {
    redirectToTopPage() {
      this.$router.push({ path: "/" })
    }
  }
}
</script>

<style>

</style>
