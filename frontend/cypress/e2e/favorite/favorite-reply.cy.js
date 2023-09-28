
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



describe("返信のいいね一覧", () => {

  it("3件の返信にいいねがされていると、お気に入り一覧ページに3件の返信が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信").click({ force: true })

    cy.get("[data-cy=each-replies]").eq(0).find("textarea").should("have.value", "いいね用返信1")

    cy.get("[data-cy=each-replies]").eq(1).find("textarea").should("have.value", "いいね用返信2")

    cy.get("[data-cy=each-replies]").eq(2).find("textarea").should("have.value", "いいね用返信3")
  })

})

describe("いいねの確認", () => {

  it("いいねしていない返信の詳細ページにアクセスすると、「いいね追加」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("質問一覧").click({ force: true })

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("いいね追加用質問1").click({ force: true })

    cy.contains("質問詳細")

    cy.contains("いいね追加用質問1")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "いいね追加用返信1").click({ force: true })

    cy.contains("返信詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("0")
    })

  it("いいねしている返信の詳細ページにアクセスすると、「いいね削除」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("質問一覧").click({ force: true })

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("いいね削除用質問1").click({ force: true })

    cy.contains("質問詳細")

    cy.contains("いいね削除用質問1")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "いいね削除用返信1").click({ force: true })

    cy.contains("返信詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("自分が投稿した返信の詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get(".v-tabs").contains("投稿した返信").click({ force: true })

    cy.get("[data-cy=each-replies]").eq(0).find("textarea").should("have.value", "サンプル返信本文1").click({ force: true })

    cy.contains("返信詳細")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("未ログイン状態で返信の詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("質問一覧").click({ force: true })

    cy.contains("サンプル質問タイトル1").click({ force: true })

    cy.contains("質問詳細")

    cy.contains("サンプル質問タイトル1")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "サンプル返信本文1").click({ force: true })

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "サンプル返信本文1")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

})

describe("返信のいいね", () => {

  it("返信詳細ページで返信にいいねすると、返信のいいね数が1増加する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("質問一覧").click({ force: true })

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("いいね追加用質問1").click({ force: true })

    cy.contains("質問詳細")

    cy.contains("いいね追加用質問1")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "いいね追加用返信1").click({ force: true })

    cy.contains("返信詳細")

    cy.get("[data-cy=favorite-section]").contains("0")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click({ force: true })

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("返信詳細ページで返信にいいねすると、お気に入り一覧に返信が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-replies]").last().find("textarea").should("not.have.value", "いいね追加用返信2")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("質問一覧").click({ force: true })

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("いいね追加用質問1").click({ force: true })

    cy.contains("質問詳細")

    cy.contains("いいね追加用質問1")

    cy.get("[data-cy=each-question-replies]").eq(1).find("textarea").should("have.value", "いいね追加用返信2").click({ force: true })

    cy.contains("返信詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click({ force: true })

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-replies]").last().find("textarea").should("have.value", "いいね追加用返信2")
  })

})

describe("返信のいいね削除", () => {

  it("返信詳細ページで返信のいいねを削除すると、返信のいいね数が1減少する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("質問一覧").click({ force: true })

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click({ force: true })

    cy.contains("いいね削除用質問1").click({ force: true })

    cy.contains("質問詳細")

    cy.contains("いいね削除用質問1")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "いいね削除用返信1").click({ force: true })

    cy.contains("返信詳細")

    cy.get("[data-cy=favorite-section]").contains("1")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click({ force: true })

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorite-section]").contains("0")
  })

  it("返信詳細ページで返信のいいねを削除すると、お気に入り一覧から返信が削除される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-replies]").first().find("textarea").should("have.value", "いいね用返信1").click({ force: true })

    cy.contains("返信詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click({ force: true })

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorites-link-button]").scrollIntoView().click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-replies]").first().find("textarea").should("not.have.value", "いいね用返信1").click({ force: true })
  })

})
