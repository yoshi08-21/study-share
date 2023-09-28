
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



describe("アンケートのいいね一覧", () => {

  it("3件のアンケートにいいねがされていると、お気に入り一覧ページに3件のアンケートが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したアンケート").click({ force: true })

    cy.contains("いいね用アンケート1")

    cy.contains("いいね用アンケート2")

    cy.contains("いいね用アンケート3")
  })

})

describe("いいねの確認", () => {

  it("いいねしていないアンケートの詳細ページにアクセスすると、「いいね追加」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("参考書").click({ force: true })

    cy.contains("いいね追加用アンケート1").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("いいね追加用アンケート1")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("0")
    })

  it("いいねしているアンケートの詳細ページにアクセスすると、「いいね削除」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("参考書").click({ force: true })

    cy.contains("いいね削除用アンケート1").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("いいね削除用アンケート1")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("自分が投稿したアンケートの詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get(".v-tabs").contains("作成したアンケート").click({ force: true })

    cy.contains("サンプルアンケートタイトル1").click({ force: true })

    cy.contains("アンケート詳細")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("未ログイン状態でアンケートの詳細ページにアクセスすると、ボタンが表示されずにいいね数だけが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.contains("サンプルアンケートタイトル1").click({ force: true })

    cy.contains("アンケート詳細")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

})

describe("アンケートのいいね", () => {

  it("アンケート詳細ページでアンケートにいいねすると、アンケートのいいね数が1増加する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("参考書").click({ force: true })

    cy.contains("いいね追加用アンケート1").click({ force: true })

    cy.contains("アンケート詳細")

    cy.get("[data-cy=favorite-section]").contains("0")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click({ force: true })

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("アンケート詳細ページでアンケートにいいねすると、お気に入り一覧にアンケートが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したアンケート").scrollIntoView().click({ force: true })

    cy.contains("いいね追加用アンケート2").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("参考書").click({ force: true })

    cy.contains("いいね追加用アンケート2").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("いいね追加用アンケート2")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").click({ force: true })

    cy.contains("いいね!しました")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したアンケート").scrollIntoView().click({ force: true })

    cy.contains("いいね追加用アンケート2")
  })

})

describe("アンケートのいいね削除", () => {

  it("アンケート詳細ページでアンケートのいいねを削除すると、アンケートのいいね数が1減少する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("参考書").click({ force: true })

    cy.contains("いいね削除用アンケート1").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("いいね削除用アンケート1")

    cy.get("[data-cy=favorite-section]").contains("1")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click({ force: true })

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorite-section]").contains("0")
  })

  it("アンケート詳細ページでアンケートのいいねを削除すると、お気に入り一覧からアンケートが削除される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したアンケート").scrollIntoView().click({ force: true })

    cy.contains("いいね削除用アンケート2")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("参考書").click({ force: true })

    cy.contains("いいね削除用アンケート2").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("いいね削除用アンケート2")

    cy.get("[data-cy=favorite-section]").find("[data-cy=remove-favorite-button]").click({ force: true })

    cy.contains("いいね!を削除しました")

    cy.get("[data-cy=favorites-link-button]").click({ force: true })

    cy.contains("お気に入り一覧")

    cy.get(".v-tabs").contains("いいね!したアンケート").scrollIntoView().click({ force: true })

    cy.contains("いいね削除用アンケート2").should("not.exist")
  })

})
