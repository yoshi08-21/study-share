
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



describe("アンケートの回答の新規作成", () => {

  it("ログイン状態でアンケートに回答すると、アンケートの回答の作成に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click({ force: true })

    cy.contains("回答作成用アンケート").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("回答作成用アンケート")

    cy.contains("回答受付中")

    cy.contains("選択肢1").click({ force: true })

    cy.contains("アンケートに回答しました")

    cy.get(".v-btn--active")

    cy.contains("アンケート回答結果")

    cy.get("[data-cy=option1-result]").contains("選択肢1")

    cy.get("[data-cy=option1-result]").contains("1件")

    cy.get("[data-cy=option1-result]").contains("100%")

    cy.get("[data-cy=option2-result]").contains("選択肢2")

    cy.get("[data-cy=option2-result]").contains("0件")

    cy.get("[data-cy=option2-result]").contains("0%")

    cy.get("[data-cy=option3-result]").contains("選択肢3")

    cy.get("[data-cy=option3-result]").contains("0件")

    cy.get("[data-cy=option3-result]").contains("0%")

    cy.get("[data-cy=option4-result]").contains("選択肢4")

    cy.get("[data-cy=option4-result]").contains("0件")

    cy.get("[data-cy=option4-result]").contains("0%")
  })

  it("未ログイン状態でアンケートに回答すると、ログインページにリダイレクトする", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click({ force: true })

    cy.contains("回答作成用アンケート").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("回答作成用アンケート")

    cy.contains("回答受付中")

    cy.contains("選択肢1").click({ force: true })

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")
  })

  it("自分が作成したアンケートには回答できない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click({ force: true })

    cy.contains("自分が作成したアンケート").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("自分が作成したアンケート")

    cy.contains("回答受付中")

    cy.get("[data-cy=option1-button]").should("have.attr", "disabled")

    cy.get("[data-cy=option2-button]").should("have.attr", "disabled")

    cy.get("[data-cy=option3-button]").should("have.attr", "disabled")

    cy.get("[data-cy=option4-button]").should("have.attr", "disabled")
  })

  it("締め切り済みのアンケートには回答できない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.contains("締め切り済みアンケート").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("締め切り済みアンケート")

    cy.contains("締め切り済み")

    cy.get("[data-cy=option1-button]").should("have.attr", "disabled")

    cy.get("[data-cy=option2-button]").should("have.attr", "disabled")

    cy.get("[data-cy=option3-button]").should("have.attr", "disabled")

    cy.get("[data-cy=option4-button]").should("have.attr", "disabled")
  })


})

describe("アンケートの回答変更", () => {

  it("回答済みのアンケートで回答を選択し直すと、回答が変更される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click({ force: true })

    cy.contains("回答変更用アンケート").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("回答変更用アンケート")

    cy.contains("回答受付中")

    cy.contains("アンケート回答結果")

    cy.get("[data-cy=option1-result]").contains("選択肢1")

    cy.get("[data-cy=option1-result]").contains("2件")

    cy.get("[data-cy=option1-result]").contains("100%")

    cy.get("[data-cy=option2-result]").contains("選択肢2")

    cy.get("[data-cy=option2-result]").contains("0件")

    cy.get("[data-cy=option2-result]").contains("0%")

    cy.contains("選択肢2").click({ force: true })

    cy.contains("回答を変更しました")

    cy.get("[data-cy=option1-result]").contains("選択肢1")

    cy.get("[data-cy=option1-result]").contains("1件")

    cy.get("[data-cy=option1-result]").contains("50%")

    cy.get("[data-cy=option2-result]").contains("選択肢2")

    cy.get("[data-cy=option2-result]").contains("1件")

    cy.get("[data-cy=option2-result]").contains("50%")
  })
})

describe("アンケートの回答削除", () => {

  it("回答済みのアンケートで自分が選択済みの回答を再度クリックすると、回答が取り消される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("アンケート").click({ force: true })

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click({ force: true })

    cy.contains("回答削除用アンケート").click({ force: true })

    cy.contains("アンケート詳細")

    cy.contains("回答削除用アンケート")

    cy.contains("回答受付中")

    cy.contains("アンケート回答結果")

    cy.get("[data-cy=option1-result]").contains("選択肢1")

    cy.get("[data-cy=option1-result]").contains("1件")

    cy.get("[data-cy=option1-result]").contains("100%")

    cy.contains("選択肢1").scrollIntoView().click({ force: true })

    cy.contains("回答を取り消しました")

    cy.contains("アンケート回答結果").should("not.exist")
  })


})

