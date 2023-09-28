
before(() => {
  cy.exec("cd ../ && cd backend && RAILS_ENV=test bundle exec rake db:reset db:seed")
});

beforeEach(() => {
  cy.visit("/")

  cy.wait(1000)

  cy.get("body").then(body => {
    if (body[0].querySelector("[data-cy=header-user-menu]")) {
        cy.get("[data-cy=header-user-menu]").click({ force: true });
        cy.get("[data-cy=header-logout-button]").should("be.visible").click({ force: true });
    }
  });
})

after(() => {
  cy.visit("/")

  cy.wait(1000)

  cy.get("body").then(body => {
    if (body[0].querySelector("[data-cy=header-user-menu]")) {
        cy.get("[data-cy=header-user-menu]").click({ force: true });
        cy.get("[data-cy=header-logout-button]").should("be.visible").click({ force: true });
    }
  });
})



describe("質問のいいね一覧", () => {

  it("3件の質問にいいねがされていると、お気に入り一覧ページに3件の質問が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した質問").click({ force: true })

    cy.contains("いいね用質問1")

    cy.contains("いいね用質問2")

    cy.contains("いいね用質問3")
  })

})

describe("いいねの確認", () => {

  it("いいねしていない質問の詳細ページにアクセスすると、「いいね追加」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("お気に入り登録用参考書1").click({ force: true })

    cy.contains("参考書詳細")

    cy.contains("お気に入り登録用参考書1")

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("いいね追加用質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("0")
    })

  it("いいねしている質問の詳細ページにアクセスすると、「いいね削除」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("お気に入り解除用参考書1").click({ force: true })

    cy.contains("参考書詳細")

    cy.contains("お気に入り解除用参考書1")

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("いいね削除用質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("自分が投稿した質問の詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get(".v-tabs").contains("投稿した質問").click({ force: true })

    cy.contains("サンプル質問タイトル1").click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("未ログイン状態で質問の詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").click({ force: true })

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("サンプル質問タイトル1").click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

})

describe("質問のいいね", () => {

  it("質問詳細ページで質問にいいねすると、質問のいいね数が1増加する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("お気に入り登録用参考書1").click({ force: true })

    cy.contains("参考書詳細")

    cy.contains("お気に入り登録用参考書1")

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("いいね追加用質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").contains("0")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click({ force: true })

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("質問詳細ページで質問にいいねすると、お気に入り一覧に質問が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した質問").scrollIntoView().click({ force: true })

    cy.contains("いいね追加用質問2").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("お気に入り登録用参考書1").click({ force: true })

    cy.contains("参考書詳細")

    cy.contains("お気に入り登録用参考書1")

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("いいね追加用質問2").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click({ force: true })

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した質問").scrollIntoView().click({ force: true })

    cy.contains("いいね追加用質問2")
  })

})

describe("質問のいいね削除", () => {

  it("質問詳細ページで質問のいいねを削除すると、質問のいいね数が1減少する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("お気に入り解除用参考書1").click({ force: true })

    cy.contains("参考書詳細")

    cy.contains("お気に入り解除用参考書1")

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("いいね削除用質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").contains("1")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click({ force: true })

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorite-section]").contains("0")
  })

  it("質問詳細ページで質問のいいねを削除すると、お気に入り一覧から質問が削除される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した質問").scrollIntoView().click({ force: true })

    cy.contains("いいね削除用質問2")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("お気に入り解除用参考書1").click({ force: true })

    cy.contains("参考書詳細")

    cy.contains("お気に入り解除用参考書1")

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("いいね削除用質問2").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click({ force: true })

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した質問").scrollIntoView().click({ force: true })

    cy.contains("いいね削除用質問2").should("not.exist")
  })

})
