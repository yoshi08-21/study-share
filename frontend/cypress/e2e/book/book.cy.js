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

describe("参考書一覧", () => {

  it("参考書が3冊登録されている状態で参考書一覧にアクセスすると、3冊の参考書が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1")

    cy.contains("サンプル参考書2")

    cy.contains("サンプル参考書3")
  })

})

describe("参考書詳細", () => {

  it("参考書詳細ページにアクセスすると、参考書の詳細情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").should("be.visible").click()

    cy.contains("サンプル参考書1")

    cy.contains("3")

    cy.contains("現代文")

    cy.contains("サンプル著者1")

    cy.contains("サンプル出版社1")

    cy.get("textarea").should("have.value", "サンプル参考書1の説明文")

    cy.get("[data-cy=book-review-section]").contains("レビュー")

    cy.get("[data-cy=book-review-section]").contains("3件")

    cy.get("[data-cy=book-question-section]").contains("質問")

    cy.get("[data-cy=book-question-section]").contains("2件")

    cy.get("[data-cy=book-favorite-section]").contains("お気に入り")

    cy.get("[data-cy=book-favorite-section]").contains("1")
  })

})


describe("参考書登録", () => {

  it("ログイン状態で参考書を登録すると、参考書の登録に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("新しい参考書を登録する").click()

    cy.contains("参考書を登録する")

    cy.contains("科目を選択する(必須)").click()

    cy.get("[data-cy=select-subject-group]").find(".v-label").first().click()

    cy.get("[data-cy=close-select-subject-dialog]").click()

    cy.contains("選択された科目:現代文")

    cy.fixture("no_image.png", { encoding: null }).as("image")

    cy.get("[data-cy=create-name-field]").type("新規サンプル参考書")

    cy.get("[data-cy=create-author-field]").type("新規サンプル著者")

    cy.get("[data-cy=create-publisher-field]").type("新規サンプル出版社")

    cy.get("[data-cy=create-description-field]").type("新規サンプル説明文")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("参考書の登録が完了しました")

    cy.contains("新規サンプル参考書")

    cy.contains("新規サンプル著者")

    cy.contains("新規サンプル出版社")

    cy.get("textarea").should("have.value", "新規サンプル説明文")
  })

  it("ログイン状態で参考書をGoogle Books APIで登録すると、参考書の登録に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("新しい参考書を登録する").click()

    cy.contains("参考書を登録する")

    cy.contains("登録する参考書を検索する").click()

    cy.get("[data-cy=google-books-api-search-books]").type("国語")

    cy.get("[data-cy=google-books-api-search-button]").click()

    cy.get("[data-cy=searched-books]").last().find("[data-cy=add-book]").click()

    cy.contains("科目を選択する(必須)").click()

    cy.get("[data-cy=select-subject-group]").find(".v-label").first().click()

    cy.get("[data-cy=close-select-subject-dialog]").click()

    cy.contains("選択された科目:現代文")

    cy.get("[data-cy=submit-book]").click()

    cy.contains("参考書の登録が完了しました")

    cy.contains("現代文")

  })

  it("ログイン状態で不正なパラメーターで参考書を登録すると、参考書の登録に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("新しい参考書を登録する").click()

    cy.contains("参考書を登録する")

    cy.get("[data-cy=create-name-field]").click().blur()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=create-author-field]").click().blur()

    cy.contains("著者を入力してください")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("参考書を登録できませんでした")

  })

  it("未ログイン状態で参考書を登録すると、ログインページにリダイレクトする", () => {
    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("新しい参考書を登録する").click()

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")

  })

})

describe("参考書編集", () => {

  it("ログイン状態で自分が投稿した参考書を編集すると、参考書の編集に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書1").should("be.visible").click()

    cy.contains("サンプル参考書1")

    cy.contains("サンプル著者1")

    cy.contains("サンプル出版社1")

    cy.contains("現代文")

    cy.get("textarea").should("have.value", "サンプル参考書1の説明文")

    cy.contains("編集する").click()

    cy.contains("科目を選択する(必須)").click()

    cy.get("[data-cy=select-subject-group]").find(".v-label").eq(1).click()

    cy.get("[data-cy=close-select-subject-dialog]").click()

    cy.contains("選択された科目:古文")

    cy.get("[data-cy=edit-name-field]").clear().type("編集後サンプル参考書")

    cy.get("[data-cy=edit-author-field]").clear().type("編集後サンプル著者")

    cy.get("[data-cy=edit-publisher-field]").clear().type("編集後サンプル出版社")

    cy.get("[data-cy=edit-description-field]").clear().type("編集後サンプル説明文")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("参考書の編集が完了しました")

    cy.contains("編集後サンプル参考書")

    cy.contains("編集後サンプル著者")

    cy.contains("編集後サンプル出版社")

    cy.contains("古文")

    cy.get("textarea").should("have.value", "編集後サンプル説明文")
  })

  it("ログイン状態で不正なパラメーターで参考書を編集すると、参考書の編集に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書2").scrollIntoView()

    cy.contains("サンプル参考書2").click()

    cy.get("[data-cy=edit-book-button]").click()

    cy.get("[data-cy=edit-name-field]").clear()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=edit-author-field]").clear()

    cy.contains("著者を入力してください")

    cy.get("[data-cy=edit-publisher-field]").clear()

    cy.get("[data-cy=edit-description-field]").clear()

    cy.get("[data-cy=submit-button]").click()

    cy.contains("参考書を編集できませんでした")
  })

  it("未ログイン状態だと、参考書の編集ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").should("be.visible").click()

    cy.contains("サンプル参考書2").scrollIntoView()

    cy.contains("サンプル参考書2").click()

    cy.contains("編集する").should("not.exist")
  })

})

describe("参考書削除", () => {

  it("ログイン状態で自分の参考書を削除すると、参考書の削除に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書2").scrollIntoView()

    cy.contains("サンプル参考書2").click()

    cy.get("[data-cy=delete-book-button]").click()

    cy.contains("参考書を削除しますか？")

    cy.get("[data-cy=delete-confirm-button]").click()

    cy.url().should("include", "/allBooks")

    cy.contains("参考書を削除しました")
  })


  it("未ログイン状態だと、参考書の削除ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.contains("サンプル参考書3").scrollIntoView()

    cy.contains("サンプル参考書3").click()

    cy.get("[data-cy=delete-book-button]").should("not.exist")
  })

})

