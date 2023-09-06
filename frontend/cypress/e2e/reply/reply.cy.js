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


describe("返信一覧", () => {

  it("返信が3件投稿されている質問の詳細にアクセスすると、3件の返信が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("英語の質問1").scrollIntoView().click()

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "英語の返信1")

    cy.get("[data-cy=each-question-replies]").eq(1).find("textarea").should("have.value", "英語の返信2")

    cy.get("[data-cy=each-question-replies]").eq(2).find("textarea").should("have.value", "英語の返信3")

  })

})

describe("返信詳細", () => {

  it("返信詳細ページにアクセスすると、返信の詳細情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("英語の質問1").scrollIntoView().click()

    cy.contains("質問詳細")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "英語の返信1").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "英語の返信1")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("返信詳細ページにアクセスすると、返信に関連する質問情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("英語の質問1").scrollIntoView().click()

    cy.contains("質問詳細")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "英語の返信1").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=question-information]").find("textarea").should("have.value", "to不定詞の使い方を教えてください")

    cy.contains("英文法の教科書")

    cy.get("[data-cy=question-reply-section]").contains("返信")

    cy.get("[data-cy=question-reply-section]").contains("3件")

    cy.get("[data-cy=question-favorite-section]").contains("いいね!")

    cy.get("[data-cy=question-favorite-section]").contains("1")
  })

})


describe("返信投稿", () => {

  it("ログイン状態で返信を投稿すると、返信の投稿に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("英語の質問2").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("textarea").should("have.value", "動名詞の使い方を教えてください")

    cy.get("[data-cy=reply-section]").contains("返信")

    cy.get("[data-cy=reply-section]").contains("0件")

    cy.contains("返信を投稿する").click()

    cy.get("[data-cy=create-content-field]").type("テスト返信本文")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "テスト返信本文")

    cy.get("[data-cy=question-reply-section]").contains("1件")
  })

  it("未ログイン状態で返信を投稿すると、ログインページにリダイレクトする", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("英語の質問2").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").click()

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")
  })

  it("ログイン状態で不正なパラメーターで返信を投稿すると、返信投稿に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("英語の質問2").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").click()

    cy.get("[data-cy=create-content-field]").click().blur()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信を投稿できませんでした")
  })

})

describe("返信編集", () => {

  it("ログイン状態で自分の返信を編集すると、返信の編集に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した返信").click()

    cy.get("[data-cy=each-replies]").eq(0).click()

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "サンプル返信本文1")

    cy.contains("編集する").click()

    cy.get("[data-cy=edit-content-field]").clear().type("編集後サンプル返信本文")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の編集が完了しました")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "編集後サンプル返信本文")
  })

  it("ログイン状態で自分の返信を不正なパラメーターで編集すると、返信の編集に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した返信").click()

    cy.get("[data-cy=each-replies]").eq(0).click()

    cy.contains("返信詳細")

    cy.contains("編集する").click()

    cy.get("[data-cy=edit-content-field]").clear()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信を編集できませんでした")
  })

  it("ログイン状態で他人の返信詳細ページにアクセスすると,返信編集ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("サンプル質問タイトル1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=each-question-replies]").eq(1).find("textarea").should("have.value", "サンプル返信本文2").click()

    cy.contains("編集する").should("not.exist")
  })

  it("未ログイン状態だと、返信の編集ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("英語の質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "英語の返信1").click()

    cy.contains("編集する").should("not.exist")
  })

})

describe.only("返信削除", () => {

  it("ログイン状態で自分の返信を削除すると、返信の削除に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get(".v-tabs").contains("投稿した返信").click()

    cy.get("[data-cy=each-replies]").eq(1).find("textarea").should("have.value", "英語の返信1").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "英語の返信1")

    cy.contains("削除する").click()

    cy.contains("返信を削除しますか？")

    cy.get("[data-cy=delete-confirm-button]").click()

    cy.contains("返信を削除しました")

    cy.visit("/mypage")

    cy.get(".v-tabs").contains("投稿した返信").click()

    cy.get("[data-cy=each-replies]").eq(1).find("textarea").should("not.have.value", "英語の返信1")
  })

  it("ログイン状態で他人の返信詳細ページにアクセスすると,返信削除ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("サンプル質問タイトル1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=each-question-replies]").eq(1).find("textarea").should("have.value", "サンプル返信本文2").click()

    cy.contains("削除する").should("not.exist")
  })


  it("未ログイン状態だと、返信の削除ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.contains("英語の質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=each-question-replies]").last().find("textarea").should("have.value", "英語の返信3").click()

    cy.contains("削除する").should("not.exist")
  })

})

