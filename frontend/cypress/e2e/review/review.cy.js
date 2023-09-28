
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

describe("レビュー一覧", () => {

  it("レビューが2件投稿されている参考書の詳細にアクセスすると、2件のレビューが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

    cy.contains("サンプルレビュータイトル1")

    cy.contains("サンプルレビュータイトル2")
  })

})

describe("レビュー詳細", () => {

it("レビュー詳細ページにアクセスすると、レビューの詳細情報が表示される", () => {
  cy.visit("/")

  cy.get("[data-cy=menu-button]").click({ force: true })

  cy.contains("参考書一覧").click({ force: true })

  cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

  cy.contains("サンプルレビュータイトル1").click({ force: true })

  cy.contains("レビュー詳細")

  cy.contains("5")

  cy.contains("サンプルレビュータイトル1")

  cy.get("textarea").should("have.value", "サンプルレビュー本文1")

  cy.get("[data-cy=favorite-section]").contains("いいね!")

  cy.get("[data-cy=favorite-section]").contains("1")
})

  it("レビュー詳細ページにアクセスすると、レビューに関連する参考書情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

    cy.contains("サンプルレビュータイトル1").click({ force: true })

    cy.contains("レビュー詳細")

    cy.contains("サンプル参考書1")

    cy.contains("現代文")

    cy.contains("サンプル著者1")

    cy.contains("サンプル出版社1")

    cy.get("[data-cy=book-review-section]").contains("レビュー")

    cy.get("[data-cy=book-review-section]").contains("3件")

    cy.get("[data-cy=book-question-section]").contains("質問")

    cy.get("[data-cy=book-question-section]").contains("3件")

    cy.get("[data-cy=book-favorite-section]").contains("お気に入り")

    cy.get("[data-cy=book-favorite-section]").contains("1")

  })


})

describe("コンテンツナビゲーター", () => {

  it("レビュー詳細ページで「次のレビュー」「前のレビュー」のナビゲーション機能が動作する", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

    cy.contains("参考書詳細")

    cy.contains("サンプルレビュータイトル1").click({ force: true })

    cy.contains("レビュー詳細")

    cy.contains("サンプルレビュータイトル1")

    cy.get("[data-cy=next-content-button]").scrollIntoView().click({ force: true })

    cy.contains("レビュー詳細")

    cy.contains("サンプルレビュータイトル2")

    cy.get("[data-cy=previous-content-button]").scrollIntoView().click({ force: true })

    cy.contains("レビュー詳細")

    cy.contains("サンプルレビュータイトル1")
  })

})

describe("レビュー投稿", () => {

  it("ログイン状態でレビューを投稿すると、レビューの投稿に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").click({ force: true })

    cy.get("[data-cy=review-dialog-button]").click({force: true})

    cy.get("[data-cy=review-title-form]").type("レビュータイトル")

    cy.get("[data-cy=review-content-form]").type("レビュー本文")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("レビューの投稿が完了しました")

    cy.contains("レビュー詳細")

    cy.contains("レビュータイトル")

    cy.get("textarea").should("have.value", "レビュー本文")
  })

  it("未ログイン状態でレビューを投稿すると、ログインページにリダイレクトする", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

    cy.get("[data-cy=review-dialog-button]").click({force: true})

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")
  })

  it("ログイン状態で不正なパラメーターでレビューを投稿すると、レビュー投稿に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

    cy.get("[data-cy=review-dialog-button]").click({force: true})

    cy.get("[data-cy=review-title-form]").click({ force: true })

    cy.get("[data-cy=review-title-form]").blur()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=review-content-form]").click({ force: true })

    cy.get("[data-cy=review-content-form]").blur()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("レビューを投稿できませんでした")
  })

})

describe("レビュー編集", () => {

  it("ログイン状態で自分のレビューを編集すると、レビューの編集に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("サンプルレビュータイトル1").click({ force: true })

    cy.contains("サンプルレビュータイトル1")

    cy.get("textarea").should("have.value", "サンプルレビュー本文1")

    cy.contains("編集する").click({ force: true })

    cy.get("[data-cy=edit-title-field]").clear().type("編集後サンプルレビュータイトル")

    cy.get("[data-cy=edit-content-field]").clear().type("編集後サンプルレビュー本文")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("レビューの編集が完了しました")

    cy.contains("編集後サンプルレビュータイトル")

    cy.get("textarea").should("have.value", "編集後サンプルレビュー本文")
  })

  it("ログイン状態で自分のレビューを不正なパラメーターで編集すると、レビューの編集に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("サンプルレビュータイトル3").click({ force: true })

    cy.contains("サンプルレビュータイトル3")

    cy.contains("編集する").click({ force: true })

    cy.get("[data-cy=edit-title-field]").clear()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=edit-content-field]").clear()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("レビューを編集できませんでした")
  })

  it("未ログイン状態だと、レビューの編集ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書2").click({ force: true })

    cy.contains("サンプルレビュータイトル3").click({ force: true })

    cy.contains("編集する").should("not.exist")
  })

})

describe("レビュー削除", () => {

  it("ログイン状態で自分のレビューを削除すると、レビューの削除に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("サンプルレビュータイトル3").click({ force: true })

    cy.contains("削除する").click({ force: true })

    cy.contains("レビューを削除しますか？")

    cy.get("[data-cy=delete-confirm-button]").click({ force: true })

    cy.contains("レビューを削除しました")

    cy.visit("/mypage")

    cy.contains("サンプルレビュータイトル3").should("not.exist")

  })

  it("未ログイン状態だと、レビューの削除ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

    cy.contains("サンプルレビュータイトル4").click({ force: true })

    cy.contains("削除する").should("not.exist")
  })

})

