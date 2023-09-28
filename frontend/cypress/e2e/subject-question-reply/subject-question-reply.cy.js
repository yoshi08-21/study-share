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


describe("科目別返信一覧", () => {

  it("科目別返信が2件投稿されている科目別質問の詳細にアクセスすると、2件の科目別返信が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.contains("サンプル科目別質問タイトル1").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "サンプル科目別返信本文1")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(1).find("textarea").should("have.value", "サンプル科目別返信本文2")
  })

})

describe("科目別返信詳細", () => {

  it("科目別返信詳細ページにアクセスすると、科目別返信の詳細情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.contains("サンプル科目別質問タイトル1").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "サンプル科目別返信本文1").click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "サンプル科目別返信本文1")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")
  })

  it("科目別返信詳細ページにアクセスすると、科目別返信に関連する質問情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.contains("サンプル科目別質問タイトル1").scrollIntoView().click({ force: true })

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "サンプル科目別返信本文1").click({ force: true })

    cy.contains("質問情報")

    cy.contains("サンプル科目別質問タイトル1")

    cy.get("[data-cy=subject-question-information]").find("textarea").should("have.value", "サンプル科目別質問本文1")

    cy.contains("科目")

    cy.contains("リスニング")

    cy.get("[data-cy=subject-question-reply-section]").contains("返信")

    cy.get("[data-cy=subject-question-reply-section]").contains("2件")

    cy.get("[data-cy=subject-question-favorite-section]").contains("いいね!")

    cy.get("[data-cy=subject-question-favorite-section]").contains("1")
  })

})

describe("コンテンツナビゲーター", () => {

  it("科目別返信詳細ページで「次の返信」「前の返信」のナビゲーション機能が動作する", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.contains("サンプル科目別質問タイトル1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").first().click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "サンプル科目別返信本文1")

    cy.get("[data-cy=next-content-button]").scrollIntoView().click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "サンプル科目別返信本文2")

    cy.get("[data-cy=previous-content-button]").scrollIntoView().click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "サンプル科目別返信本文1")
  })

})

describe("科目別返信投稿", () => {

  it("ログイン状態で科目別返信を投稿すると、科目別返信の投稿に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.contains("英語の科目別質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.get("[data-cy=subject-question-detail]").find("textarea").should("have.value", "to不定詞の使い方を教えてください")

    cy.get("[data-cy=subject-question-reply-section]").contains("返信")

    cy.get("[data-cy=subject-question-reply-section]").contains("0件")

    cy.contains("返信を投稿する").click({ force: true })

    cy.get("[data-cy=create-content-field]").type("テスト科目別返信本文")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("返信の投稿が完了しました")

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "テスト科目別返信本文")

    cy.get("[data-cy=subject-question-reply-section]").contains("1件")
  })

  it("未ログイン状態で科目別返信を投稿すると、ログインページにリダイレクトする", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.contains("英語の科目別質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").click({ force: true })

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")
  })

  it("ログイン状態で不正なパラメーターで科目別返信を投稿すると、科目別返信投稿に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.contains("英語の科目別質問1").scrollIntoView().click({ force: true })

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").click({ force: true })

    cy.get("[data-cy=create-content-field]").click({ force: true }).blur()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("返信を投稿できませんでした")
  })

})

describe("科目別返信編集", () => {

  it("ログイン状態で自分の科目別返信を編集すると、科目別返信の編集に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click({ force: true })

    cy.contains("編集用科目別質問").click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "編集用科目別返信").click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.contains("編集する").click({ force: true })

    cy.get("[data-cy=edit-content-field]").clear().type("編集後サンプル科目別返信本文")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("返信の編集が完了しました")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "編集後サンプル科目別返信本文")
  })

  it("ログイン状態で自分の科目別返信を不正なパラメーターで編集すると、科目別返信の編集に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click({ force: true })

    cy.contains("編集失敗用科目別質問").click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "編集失敗用科目別返信").click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.contains("編集する").click({ force: true })

    cy.get("[data-cy=edit-content-field]").clear()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("返信を編集できませんでした")
  })

  it("ログイン状態で他人の科目別返信詳細ページにアクセスすると,科目別返信編集ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click({ force: true })

    cy.contains("他ユーザー投稿科目別質問タイトル").click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "他ユーザー投稿科目別返信").click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.contains("編集する").should("not.exist")
  })

  it("未ログイン状態だと、科目別返信の編集ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click({ force: true })

    cy.contains("編集失敗用科目別質問").click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "編集失敗用科目別返信").click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.contains("編集する").should("not.exist")
  })

})

describe("科目別返信削除", () => {

  it("ログイン状態で自分の科目別返信を削除すると、科目別返信の削除に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click({ force: true })

    cy.contains("削除用科目別質問").click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "削除用科目別返信").click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.contains("削除する").click({ force: true })

    cy.contains("返信を削除しますか？")

    cy.get("[data-cy=delete-confirm-button]").click({ force: true })

    cy.contains("返信を削除しました")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").should("not.exist")
  })

  it("ログイン状態で他人の科目別返信詳細ページにアクセスすると,科目別返信削除ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click({ force: true })

    cy.contains("他ユーザー投稿科目別質問タイトル").click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "他ユーザー投稿科目別返信").click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.contains("削除する").should("not.exist")
  })


  it("未ログイン状態だと、科目別返信の削除ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("科目別質問一覧").click({ force: true })

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("その他科目").click({ force: true })

    cy.contains("削除失敗用科目別質問").click({ force: true })

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "削除失敗用科目別返信").click({ force: true })

    cy.contains("返信詳細(科目別)")

    cy.contains("削除する").should("not.exist")
  })

})

