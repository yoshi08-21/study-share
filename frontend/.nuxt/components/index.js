export const ContentNavigator = () => import('../../components/global/ContentNavigator.vue' /* webpackChunkName: "components/content-navigator" */).then(c => wrapFunctional(c.default || c))
export const DeleteConfirmationDialog = () => import('../../components/global/DeleteConfirmationDialog.vue' /* webpackChunkName: "components/delete-confirmation-dialog" */).then(c => wrapFunctional(c.default || c))
export const FavoriteButton = () => import('../../components/global/FavoriteButton.vue' /* webpackChunkName: "components/favorite-button" */).then(c => wrapFunctional(c.default || c))
export const NormalHeader = () => import('../../components/global/NormalHeader.vue' /* webpackChunkName: "components/normal-header" */).then(c => wrapFunctional(c.default || c))
export const ShowFullImageDialog = () => import('../../components/global/ShowFullImageDialog.vue' /* webpackChunkName: "components/show-full-image-dialog" */).then(c => wrapFunctional(c.default || c))
export const ShowSnackbar = () => import('../../components/global/ShowSnackbar.vue' /* webpackChunkName: "components/show-snackbar" */).then(c => wrapFunctional(c.default || c))
export const SpecialHeader = () => import('../../components/global/SpecialHeader.vue' /* webpackChunkName: "components/special-header" */).then(c => wrapFunctional(c.default || c))
export const SubmitButton = () => import('../../components/global/SubmitButton.vue' /* webpackChunkName: "components/submit-button" */).then(c => wrapFunctional(c.default || c))

// nuxt/nuxt.js#8607
function wrapFunctional(options) {
  if (!options || !options.functional) {
    return options
  }

  const propKeys = Array.isArray(options.props) ? options.props : Object.keys(options.props || {})

  return {
    render(h) {
      const attrs = {}
      const props = {}

      for (const key in this.$attrs) {
        if (propKeys.includes(key)) {
          props[key] = this.$attrs[key]
        } else {
          attrs[key] = this.$attrs[key]
        }
      }

      return h(options, {
        on: this.$listeners,
        attrs,
        props,
        scopedSlots: this.$scopedSlots,
      }, this.$slots.default)
    }
  }
}
