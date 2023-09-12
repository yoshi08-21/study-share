
before(() => {
  cy.exec("cd ../ && cd backend && RAILS_ENV=test bundle exec rake db:reset db:seed")
});

beforeEach(() => {
  cy.visit("/")

  cy.wait(1000)

  cy.get("body").then(body => {
    if (body[0].querySelector("[data-cy=header-user-menu]")) {
        cy.get("[data-cy=header-user-menu]").click();
        cy.get("[data-cy=header-logout-button]").should("be.visible").click();
    }
  });
})

after(() => {
  cy.visit("/")

  cy.wait(1000)

  cy.get("body").then(body => {
    if (body[0].querySelector("[data-cy=header-user-menu]")) {
        cy.get("[data-cy=header-user-menu]").click();
        cy.get("[data-cy=header-logout-button]").should("be.visible").click();
    }
  });
})



describe("レビューのいいね一覧", () => {

  it("3件のレビューにいいねがされていると、お気に入り一覧ページに3件のレビューが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したレビュー").click()

    cy.contains("いいね用レビュー1")

    cy.contains("いいね用レビュー2")

    cy.contains("いいね用レビュー3")
  })

})

describe("いいねの確認", () => {

  it("いいねしていないレビューの詳細ページにアクセスすると、「いいね追加」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り登録用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り登録用参考書1")

    cy.contains("いいね追加用レビュー1").scrollIntoView().click({ force: true })

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("0")
    })

  it("いいねしているレビューの詳細ページにアクセスすると、「いいね削除」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り解除用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り解除用参考書1")

    cy.contains("いいね削除用レビュー1").scrollIntoView().click({ force: true })

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("自分が投稿したレビューの詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.contains("サンプルレビュータイトル1").click()

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("未ログイン状態でレビューの詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").click()

    cy.contains("サンプルレビュータイトル1").click()

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

})

describe("レビューのいいね", () => {

  it("レビュー詳細ページでレビューにいいねすると、レビューのいいね数が1増加する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り登録用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り登録用参考書1")

    cy.contains("いいね追加用レビュー1").scrollIntoView().click({ force: true })

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").contains("0")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click()

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("レビュー詳細ページでレビューにいいねすると、お気に入り一覧にレビューが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したレビュー").scrollIntoView().click({ force: true })

    cy.contains("いいね追加用レビュー2").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り登録用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り登録用参考書1")

    cy.contains("いいね追加用レビュー2").scrollIntoView().click({ force: true })

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click()

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したレビュー").scrollIntoView().click({ force: true })

    cy.contains("いいね追加用レビュー2")
  })

})

describe("レビューのいいね削除", () => {

  it("レビュー詳細ページでレビューのいいねを削除すると、レビューのいいね数が1減少する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り解除用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り解除用参考書1")

    cy.contains("いいね削除用レビュー1").scrollIntoView().click({ force: true })

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").contains("1")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click()

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorite-section]").contains("0")
  })

  it("レビュー詳細ページでレビューのいいねを削除すると、お気に入り一覧からレビューが削除される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したレビュー").scrollIntoView().click({ force: true })

    cy.contains("いいね削除用レビュー2")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り解除用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り解除用参考書1")

    cy.contains("いいね削除用レビュー2").scrollIntoView().click({ force: true })

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click()

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したレビュー").scrollIntoView().click({ force: true })

    cy.contains("いいね削除用レビュー2").should("not.exist")
  })

})
