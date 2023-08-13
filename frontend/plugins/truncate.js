import Vue from 'vue'

Vue.prototype.$truncate = (str, length) => {
  return str.length > length ? str.substring(0, length) + "..." : str;
}
