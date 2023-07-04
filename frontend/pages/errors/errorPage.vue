<template>
  <div>
    <h2>エラーページ</h2>
    <p>存在しないページです</p>
    <v-btn  @click="redirectToTopPage">トップページに戻る</v-btn>
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
