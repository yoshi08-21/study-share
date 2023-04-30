<template>
  <div>
    <h2>レビュー詳細</h2>
    <h3>レビューid:{{ this.$route.params.id }}</h3>

    <h4>参考書情報</h4>
    <p>タイトル:{{ book.name }}</p>

    <h3>レビュー</h3>
    <h4>タイトル:{{ review.title }}</h4>
    <p>本文:{{ review.content }}</p>
    <p>reviewd by {{ user.name }}</p>
  </div>
</template>

<script>

import axios from "@/plugins/axios"


export default {
  async asyncData({ params }) {
    const responce = await axios.get(`/books/${params.book_id}/reviews/${params.id}`)
    console.log(responce.data.review)
    console.log(responce.data.book)
    console.log(responce.data.review.user)
    return {
      book: responce.data.book,
      review: responce.data.review,
      user: responce.data.review.user,
      params
    };
  }
}
</script>

<style>

</style>
