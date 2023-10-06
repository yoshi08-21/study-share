import axios from "../plugins/axios"

export default async function({ store }) {
  try {
    let currentUserId = null
    const currentUser = store.getters["auth/getCurrentUser"]
    if (currentUser && currentUser.id) {
      currentUserId = currentUser.id
    }

    const response = await axios.get("/notifications/check_unread_notifications", {
      params: {
        current_user_id: currentUserId
      }
    })
    if(response.status === 200) {
      store.dispatch("notifications/setUnreadNotifications", true)
    } else {
      store.dispatch("notifications/setUnreadNotifications", false)
    }
  } catch(error) {

  }
}

