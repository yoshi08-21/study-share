import { shallowMount, createLocalVue } from '@vue/test-utils';
import ReviewDetailPage from 'frontend/pages/books/_book_id/reviews/_id.vue';
import Vuex from 'vuex';
import Vuetify from 'vuetify';

const localVue = createLocalVue();
localVue.use(Vuex);
localVue.use(Vuetify);

describe('ReviewDetailPage.vue', () => {
  let store;
  let vuetify;
  let wrapper;
  let getters;

  beforeEach(() => {
    vuetify = new Vuetify();

    getters = {
      "auth/getCurrentUser": jest.fn()
    };

    store = new Vuex.Store({
      getters
    });

    wrapper = shallowMount(ReviewDetailPage, {
      store,
      localVue,
      vuetify,
      mocks: {
        $route: {
          params: {
            book_id: 'sample_book_id',
            id: 'sample_review_id'
          }
        }
      }
    });
  });

  it('renders book information', () => {
    expect(wrapper.findComponent({ name: 'BookInformation' }).exists()).toBe(true);
  });

  it('renders review title', () => {
    expect(wrapper.find('v-card-subtitle').text()).toContain(wrapper.vm.review.title);
  });

  it('renders review rating', () => {
    expect(wrapper.find('v-rating').attributes('value')).toBe(wrapper.vm.review.rating.toString());
  });

  it('renders review content', () => {
    expect(wrapper.find('v-textarea').attributes('value')).toBe(wrapper.vm.review.content);
  });

  it('renders user avatar', () => {
    expect(wrapper.find('v-avatar').exists()).toBe(true);
  });

  // ...他のテストも同様に追加してください...

  afterEach(() => {
    wrapper.destroy();
  });
});
