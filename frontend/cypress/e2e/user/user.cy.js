
before(() => {
  cy.exec('cd ../ && cd backend && RAILS_ENV=test bundle exec rake db:reset db:seed')
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



describe("ログイン", () => {

  it("ログインに成功する", () => {
    cy.visit("/")

    cy.contains("ログイン").click({ force: true })

    cy.get("[data-cy=email-field]").type("cypress@cypress.com")

    cy.get("[data-cy=email-field]").should("have.value", "cypress@cypress.com")

    cy.get("[data-cy=password-field]").type("cypress")

    cy.get("[data-cy=password-field]").should("have.value", "cypress")

    cy.get("[data-cy=login-button]").click({ force: true })

    cy.contains("プロフィール")
  })

  it("入力フォームが空白だとログインに失敗する", () => {
    cy.visit("/")

    cy.contains("ログイン").click({ force: true })

    cy.get("[data-cy=email-field]").click({ force: true })

    cy.get("[data-cy=email-field]").blur()

    cy.contains("メールアドレスを入力してください")

    cy.get("[data-cy=password-field]").click({ force: true })

    cy.get("[data-cy=password-field]").blur()

    cy.contains("パスワードを入力してください")

    cy.get("[data-cy=login-button]").click({ force: true })

    cy.contains("ログイン")

  })

})

describe("ログアウト", () => {

  it("ログアウトに成功すると、マイページにアクセスできなくなる", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.url().should("include", "/mypage")

    cy.contains("プロフィール")

    cy.get("[data-cy=header-user-menu]").click({ force: true });

    cy.get("[data-cy=header-logout-button]").should('be.visible').click({ force: true });

    cy.contains("ログアウトしました")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("マイページ").click({ force: true })

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")
  })

})


describe("マイページ", () => {


  it("自分の投稿の取得", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("サンプルレビュータイトル1")

    cy.get(".v-tabs").contains("投稿した質問").click({ force: true })

    cy.contains("サンプル質問タイトル1")

    cy.get(".v-tabs").contains("投稿した科目別質問").click({ force: true })

    cy.contains("サンプル科目別質問タイトル1")

    cy.get(".v-tabs").contains("投稿した返信").click({ force: true })

    cy.get("[data-cy=tab-content]").find("textarea").should("have.value", "サンプル返信本文1")

    cy.get(".v-tabs").contains("投稿した返信(科目別質問)").click({ force: true })

    cy.get("[data-cy=tab-content]").find("textarea").should("have.value", "サンプル科目別返信本文1")

    cy.get(".v-tabs").contains("作成したアンケート").click({ force: true })

    cy.contains("サンプルアンケートタイトル1")

  })

})


describe("他ユーザーの詳細ページ", () => {

  it("他ユーザーの詳細ページにアクセスすると、他ユーザーの詳細情報が取得できる", () => {

    cy.visit("/users/2")

    cy.contains("edit-cypress-sample")

    cy.contains("D大学")

    cy.contains("E大学")

    cy.contains("F大学")

    cy.get("textarea").should("have.value", "頑張ります")

  })

  it("他ユーザーの詳細ページにアクセスすると、他ユーザーの投稿が取得できる", () => {

    cy.visit("/users/2")

    cy.contains("edit-cypress-sample")

    cy.contains("サンプルレビュータイトル2")

    cy.get(".v-tabs").contains("投稿した質問").click({ force: true })

    cy.contains("サンプル質問タイトル2")

    cy.get(".v-tabs").contains("投稿した科目別質問").click({ force: true })

    cy.contains("サンプル科目別質問タイトル2")

    cy.get(".v-tabs").contains("投稿した返信").click({ force: true })

    cy.get("[data-cy=tab-content]").find("textarea").should("have.value", "サンプル返信本文2")

    cy.get(".v-tabs").contains("投稿した返信(科目別質問)").click({ force: true })

    cy.get("[data-cy=tab-content]").find("textarea").should("have.value", "サンプル科目別返信本文2")

    cy.get(".v-tabs").contains("作成したアンケート").click({ force: true })

    cy.contains("サンプルアンケートタイトル2")

  })


})

describe("ユーザー編集", () => {

  it("ログイン後にユーザー情報を変更すると、変更に成功する", () => {

    cy.login("edit_cypress@cypress.com", "cypress")

    cy.url().should("include", "/mypage")

    cy.contains("edit-cypress-sample")

    cy.contains("D大学")

    cy.contains("E大学")

    cy.contains("F大学")

    cy.get("textarea").should("have.value", "頑張ります")

    cy.contains("ユーザー編集").click({ force: true })

    cy.get("[data-cy=edit-name-field]").clear().type("edited-cypress-sample")

    cy.get("[data-cy=edit-introduction-field]").clear().type("こんにちは")

    cy.get("[data-cy=edit-first-choice-school-field]").clear().type("X大学")

    cy.get("[data-cy=edit-second-choice-school-field]").clear().type("Y大学")

    cy.get("[data-cy=edit-third-choice-school-field]").clear().type("Z大学")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("ユーザーの編集が完了しました")

    cy.contains("edited-cypress-sample")

    cy.contains("X大学")

    cy.contains("Y大学")

    cy.contains("Z大学")

    cy.get("textarea").should("have.value", "こんにちは");

  })

})

describe("ユーザーメモ", () => {

  it("ログイン状態でユーザーメモを保存すると、保存に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=user-memo-button]").click({ force: true })

    cy.get("[data-cy=user-memo-field]").should("have.value", "参考書Aが気になる");

    cy.get("[data-cy=user-memo-field]").clear().type("新しいメモ")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("メモを保存しました")

    cy.get("[data-cy=user-memo-field]").should("have.value", "新しいメモ");
  })

  it("未ログインだとユーザーメモボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=user-memo-button]").should("not.exist")
  })


})

