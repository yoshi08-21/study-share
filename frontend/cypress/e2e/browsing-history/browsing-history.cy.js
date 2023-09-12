
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



describe("閲覧履歴一覧", () => {


  it("3冊の参考書を閲覧していると、3冊の参考書が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=header-user-menu]").click()

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.contains("サンプル参考書1")

    cy.contains("サンプル参考書2")

    cy.contains("サンプル参考書3")
  })

  it("3件のレビューを閲覧していると、3件のレビューが閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=header-user-menu]").click()

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したレビュー").click({ force: true })

    cy.contains("サンプルレビュータイトル1")

    cy.contains("サンプルレビュータイトル2")

    cy.contains("サンプルレビュータイトル3")
  })

  it("3件の質問を閲覧していると、3件の質問が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=header-user-menu]").click()

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した質問").click({ force: true })

    cy.contains("サンプル質問タイトル1")

    cy.contains("サンプル質問タイトル2")

    cy.contains("サンプル質問タイトル3")
  })

  it("3件の返信を閲覧していると、3件の返信が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=header-user-menu]").click()

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信").click({ force: true })

    cy.get("[data-cy=each-replies]").eq(0).find("textarea").should("have.value", "サンプル返信本文1")

    cy.get("[data-cy=each-replies]").eq(1).find("textarea").should("have.value", "サンプル返信本文2")

    cy.get("[data-cy=each-replies]").eq(2).find("textarea").should("have.value", "英語の返信1")
  })

  it("3件の科目別質問を閲覧していると、3件の科目別質問が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=header-user-menu]").click()

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した科目別質問").click({ force: true })

    cy.contains("サンプル科目別質問タイトル1")

    cy.contains("サンプル科目別質問タイトル2")

    cy.contains("サンプル科目別質問タイトル3")
  })

  it("3件の科目別返信を閲覧していると、3件の科目別返信が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=header-user-menu]").click()

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信(科目別質問)").click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").eq(0).find("textarea").should("have.value", "サンプル科目別返信本文1")

    cy.get("[data-cy=each-subject-question-replies]").eq(1).find("textarea").should("have.value", "サンプル科目別返信本文2")

    cy.get("[data-cy=each-subject-question-replies]").eq(2).find("textarea").should("have.value", "サンプル科目別返信本文3")
  })

  it("3件のアンケートを閲覧していると、3件のアンケートが閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=header-user-menu]").click()

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したアンケート").click({ force: true })

    cy.contains("サンプルアンケートタイトル1")

    cy.contains("サンプルアンケートタイトル2")

    cy.contains("サンプルアンケートタイトル3")
  })

  it("未ログイン状態だと、閲覧履歴一覧にアクセスするボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").should("not.exist")
  })

})

describe("閲覧履歴の作成", () => {

  it("ログイン状態で参考書詳細ページにアクセスすると、参考書が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get("[data-cy=each-books]").last().contains("閲覧履歴作成用参考書1").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("閲覧履歴作成用参考書1")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get("[data-cy=each-books]").last().contains("閲覧履歴作成用参考書1")
  })

  it("ログイン状態でレビュー詳細ページにアクセスすると、レビューが閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したレビュー").click({ force: true })

    cy.get("[data-cy=each-reviews]").last().contains("閲覧履歴作成用レビュー1").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("閲覧履歴作成用参考書1")

    cy.contains("閲覧履歴作成用レビュー1").click()

    cy.contains("レビュー詳細")

    cy.contains("閲覧履歴作成用レビュー1")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したレビュー").click({ force: true })

    cy.get("[data-cy=each-reviews]").last().contains("閲覧履歴作成用レビュー1")
  })

  it("ログイン状態で質問詳細ページにアクセスすると、質問が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した質問").click({ force: true })

    cy.get("[data-cy=each-questions]").last().contains("閲覧履歴作成用質問1").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("閲覧履歴作成用参考書1")

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("閲覧履歴作成用質問1").click()

    cy.contains("質問詳細")

    cy.contains("閲覧履歴作成用質問1")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した質問").click({ force: true })

    cy.get("[data-cy=each-questions]").last().contains("閲覧履歴作成用質問1")
  })

  it("ログイン状態で返信詳細ページにアクセスすると、返信が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信").click({ force: true })

    cy.get("[data-cy=each-replies]").last().find("textarea").should("not.have.value", "閲覧履歴作成用返信1")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用質問1").click()

    cy.contains("質問詳細")

    cy.contains("閲覧履歴作成用質問1")

    cy.get("[data-cy=each-question-replies]").first().find("textarea").should("have.value", "閲覧履歴作成用返信1").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "閲覧履歴作成用返信1")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信").click({ force: true })

    cy.get("[data-cy=each-replies]").last().find("textarea").should("have.value", "閲覧履歴作成用返信1")
  })

  it("ログイン状態で科目別質問詳細ページにアクセスすると、科目別質問が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した科目別質問").click({ force: true })

    cy.get("[data-cy=each-subject-questions]").last().contains("閲覧履歴作成用科目別質問1").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("閲覧履歴作成用科目別質問1")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した科目別質問").click({ force: true })

    cy.get("[data-cy=each-subject-questions]").last().contains("閲覧履歴作成用科目別質問1")
  })

  it("ログイン状態で科目別返信詳細ページにアクセスすると、科目別返信が閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信(科目別質問)").click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").last().find("textarea").should("not.have.value","閲覧履歴作成用科目別返信1")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("閲覧履歴作成用科目別質問1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").first().find("textarea").should("have.value","閲覧履歴作成用科目別返信1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "閲覧履歴作成用科目別返信1")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信(科目別質問)").click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").last().find("textarea").should("have.value","閲覧履歴作成用科目別返信1")
  })

  it("ログイン状態でアンケート詳細ページにアクセスすると、アンケートが閲覧履歴一覧に表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したアンケート").click({ force: true })

    cy.get("[data-cy=each-surveys]").last().contains("閲覧履歴作成用アンケート1").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("進路・大学").click()

    cy.contains("閲覧履歴作成用アンケート1").click()

    cy.contains("アンケート詳細")

    cy.contains("閲覧履歴作成用アンケート1")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したアンケート").click({ force: true })

    cy.get("[data-cy=each-surveys]").last().contains("閲覧履歴作成用アンケート1")
  })

})

describe("閲覧履歴の削除", () => {

  it("参考書の閲覧履歴が10件存在する状態で参考書詳細ページにアクセスすると、一番古い閲覧履歴が削除され、参考書の新しい閲覧履歴が作成される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get("[data-cy=each-books]").should("have.length", 10)

    cy.get("[data-cy=each-books]").last().contains("閲覧履歴作成用参考書2").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用参考書2").click()

    cy.contains("参考書詳細")

    cy.contains("閲覧履歴作成用参考書2")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get("[data-cy=each-books]").should("have.length", 10)

    cy.get("[data-cy=each-books]").last().contains("閲覧履歴作成用参考書2")
  })

  it("レビューの閲覧履歴が10件存在する状態でレビュー詳細ページにアクセスすると、一番古い閲覧履歴が削除され、レビューの新しい閲覧履歴が作成される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したレビュー").click({ force: true })

    cy.get("[data-cy=each-reviews]").last().contains("閲覧履歴作成用レビュー2").should("not.exist")

    cy.get("[data-cy=each-reviews]").should("have.length", 10)

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("閲覧履歴作成用参考書1")

    cy.contains("閲覧履歴作成用レビュー2").click()

    cy.contains("レビュー詳細")

    cy.contains("閲覧履歴作成用レビュー2")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したレビュー").click({ force: true })

    cy.get("[data-cy=each-reviews]").last().contains("閲覧履歴作成用レビュー2")

    cy.get("[data-cy=each-reviews]").should("have.length", 10)
  })

  it("質問の閲覧履歴が10件存在する状態で質問詳細ページにアクセスすると、一番古い閲覧履歴が削除され、質問の新しい閲覧履歴が作成される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した質問").click({ force: true })

    cy.get("[data-cy=each-questions]").last().contains("閲覧履歴作成用質問2").should("not.exist")

    cy.get("[data-cy=each-questions]").should("have.length", 10)

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("閲覧履歴作成用参考書1")

    cy.get(".v-tabs").contains("質問").click({ force: true })

    cy.contains("閲覧履歴作成用質問2").click()

    cy.contains("質問詳細")

    cy.contains("閲覧履歴作成用質問2")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した質問").click({ force: true })

    cy.get("[data-cy=each-questions]").last().contains("閲覧履歴作成用質問2")

    cy.get("[data-cy=each-questions]").should("have.length", 10)
  })

  it("返信の閲覧履歴が10件存在する状態で返信詳細ページにアクセスすると、一番古い閲覧履歴が削除され、返信の新しい閲覧履歴が作成される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信").click({ force: true })

    cy.get("[data-cy=each-replies]").last().find("textarea").should("not.have.value", "閲覧履歴作成用返信2")

    cy.get("[data-cy=each-replies]").should("have.length", 10)

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用質問1").click()

    cy.contains("質問詳細")

    cy.contains("閲覧履歴作成用質問1")

    cy.get("[data-cy=each-question-replies]").eq(1).find("textarea").should("have.value", "閲覧履歴作成用返信2").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "閲覧履歴作成用返信2")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信").click({ force: true })

    cy.get("[data-cy=each-replies]").last().find("textarea").should("have.value", "閲覧履歴作成用返信2")

    cy.get("[data-cy=each-replies]").should("have.length", 10)
  })

  it("科目別質問の閲覧履歴が10件存在する状態で科目別質問詳細ページにアクセスすると、一番古い閲覧履歴が削除され、科目別質問の新しい閲覧履歴が作成される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した科目別質問").click({ force: true })

    cy.get("[data-cy=each-subject-questions]").last().contains("閲覧履歴作成用科目別質問2").should("not.exist")

    cy.get("[data-cy=each-subject-questions]").should("have.length", 10)

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用科目別質問2").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("閲覧履歴作成用科目別質問2")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した科目別質問").click({ force: true })

    cy.get("[data-cy=each-subject-questions]").last().contains("閲覧履歴作成用科目別質問2")

    cy.get("[data-cy=each-subject-questions]").should("have.length", 10)
  })

  it("科目別返信の閲覧履歴が10件存在する状態で科目別返信詳細ページにアクセスすると、一番古い閲覧履歴が削除され、科目別返信の新しい閲覧履歴が作成される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信(科目別質問)").click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").last().find("textarea").should("not.have.value","閲覧履歴作成用科目別返信2")

    cy.get("[data-cy=each-subject-question-replies]").should("have.length", 10)

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("閲覧履歴作成用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("閲覧履歴作成用科目別質問1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(1).find("textarea").should("have.value","閲覧履歴作成用科目別返信2").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "閲覧履歴作成用科目別返信2")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧した返信(科目別質問)").click({ force: true })

    cy.get("[data-cy=each-subject-question-replies]").last().find("textarea").should("have.value","閲覧履歴作成用科目別返信2")

    cy.get("[data-cy=each-subject-question-replies]").should("have.length", 10)
  })

  it("アンケートの閲覧履歴が10件存在する状態でアンケート詳細ページにアクセスすると、一番古い閲覧履歴が削除され、アンケートの新しい閲覧履歴が作成される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したアンケート").click({ force: true })

    cy.get("[data-cy=each-surveys]").last().contains("閲覧履歴作成用アンケート2").should("not.exist")

    cy.get("[data-cy=each-surveys]").should("have.length", 10)

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("進路・大学").click()

    cy.contains("閲覧履歴作成用アンケート2").click()

    cy.contains("アンケート詳細")

    cy.contains("閲覧履歴作成用アンケート2")

    cy.visit("/")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("閲覧履歴").click()

    cy.contains("閲覧履歴一覧")

    cy.get(".v-tabs").contains("閲覧したアンケート").click({ force: true })

    cy.get("[data-cy=each-surveys]").last().contains("閲覧履歴作成用アンケート2")

    cy.get("[data-cy=each-surveys]").should("have.length", 10)
  })


})

