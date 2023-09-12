
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



describe("科目別返信のいいね一覧", () => {

  it("3件の科目別返信にいいねがされていると、お気に入り一覧ページに3件の科目別返信が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信(科目別質問)").click()

    cy.get("[data-cy=each-subject-question-replies]").eq(0).find("textarea").should("have.value", "いいね用科目別返信1")

    cy.get("[data-cy=each-subject-question-replies]").eq(1).find("textarea").should("have.value", "いいね用科目別返信2")

    cy.get("[data-cy=each-subject-question-replies]").eq(2).find("textarea").should("have.value", "いいね用科目別返信3")
  })

})

describe("いいねの確認", () => {

  it("いいねしていない科目別返信の詳細ページにアクセスすると、「いいね追加」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("いいね追加用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("いいね追加用科目別質問1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "いいね追加用科目別返信1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("0")
    })

  it("いいねしている科目別返信の詳細ページにアクセスすると、「いいね削除」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("いいね削除用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("いいね削除用科目別質問1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "いいね削除用科目別返信1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("自分が投稿した科目別返信の詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get(".v-tabs").contains("投稿した返信(科目別質問)").click()

    cy.get("[data-cy=each-subject-question-replies]").eq(0).find("textarea").should("have.value", "サンプル科目別返信本文1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("未ログイン状態で科目別返信の詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.contains("サンプル科目別質問タイトル1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("サンプル科目別質問タイトル1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "サンプル科目別返信本文1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "サンプル科目別返信本文1")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

})

describe("科目別返信のいいね", () => {

  it("返信詳細(科目別)ページで科目別返信にいいねすると、科目別返信のいいね数が1増加する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("いいね追加用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("いいね追加用科目別質問1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "いいね追加用科目別返信1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=favorite-section]").contains("0")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click()

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("返信詳細(科目別)ページで科目別返信にいいねすると、お気に入り一覧に科目別返信が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信(科目別質問)").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").last().find("textarea").should("not.have.value", "いいね追加用科目別返信2")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("いいね追加用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("いいね追加用科目別質問1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(1).find("textarea").should("have.value", "いいね追加用科目別返信2").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click()

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信(科目別質問)").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").last().find("textarea").should("have.value", "いいね追加用科目別返信2")
  })

})

describe("科目別返信のいいね削除", () => {

  it("返信詳細(科目別)ページで科目別返信のいいねを削除すると、科目別返信のいいね数が1減少する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("いいね削除用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("いいね削除用科目別質問1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "いいね削除用科目別返信1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=favorite-section]").contains("1")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click()

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorite-section]").contains("0")
  })

  it("返信詳細(科目別)ページで科目別返信のいいねを削除すると、お気に入り一覧から科目別返信が削除される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信(科目別質問)").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").first().find("textarea").should("have.value", "いいね用科目別返信1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click()

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorites-link-button]").scrollIntoView().click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!した返信(科目別質問)").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").first().find("textarea").should("not.have.value", "いいね用科目別返信1").click()
  })

})
