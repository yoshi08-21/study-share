export { default as ContentNavigator } from '../../components/global/ContentNavigator.vue'
export { default as DeleteConfirmationDialog } from '../../components/global/DeleteConfirmationDialog.vue'
export { default as FavoriteButton } from '../../components/global/FavoriteButton.vue'
export { default as NormalHeader } from '../../components/global/NormalHeader.vue'
export { default as ShowSnackbar } from '../../components/global/ShowSnackbar.vue'
export { default as SpecialHeader } from '../../components/global/SpecialHeader.vue'
export { default as SubmitButton } from '../../components/global/SubmitButton.vue'

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
