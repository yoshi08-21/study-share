import axios from "axios"

export default axios.create ({
  baseURL: process.env.API_BASE_URL
})

console.log("apiBaseUrl:", process.env.API_BASE_URL)
