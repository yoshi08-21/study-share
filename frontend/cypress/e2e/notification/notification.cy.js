
before(() => {
  cy.exec("cd ../ && cd backend && RAILS_ENV=test bundle exec rake db:reset db:seed")
});

beforeEach(() => {
  cy.visit("/")

  cy.wait(1000)

  cy.get("body").then(body => {
    if (body[0].querySelector("[data-cy=header-user-menu]")) {
        cy.get("[data-cy=header-user-menu]").click();
        cy.get("[data-cy=header-logout-button]").click();
    }
  });
})

after(() => {
  cy.visit("/")

  cy.wait(1000)

  cy.get("body").then(body => {
    if (body[0].querySelector("[data-cy=header-user-menu]")) {
        cy.get("[data-cy=header-user-menu]").click();
        cy.get("[data-cy=header-logout-button]").click();
    }
  });
})



describe("通知一覧", () => {


  it("通知一覧にアクセスすると、自分のレビューに対するいいねの通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(8).contains("あなたのレビューにいいね!しました")
  })

  it("通知一覧にアクセスすると、自分の質問に対するいいねの通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(7).contains("あなたの質問にいいね!しました")
  })

  it("通知一覧にアクセスすると、自分の質問に対するいいねの通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(6).contains("あなたの返信にいいね!しました")
  })

  it("通知一覧にアクセスすると、自分の質問(科目別)に対するいいねの通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(5).contains("あなたの質問(科目別)にいいね!しました")
  })

  it("通知一覧にアクセスすると、自分の返信(科目別)に対するいいねの通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(4).contains("あなたの返信(科目別)にいいね!しました")
  })

  it("通知一覧にアクセスすると、自分のアンケートに対するいいねの通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(3).contains("あなたのアンケートにいいね!しました")
  })

  it("通知一覧にアクセスすると、自分の質問に対する返信の通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(2).contains("あなたの質問")

    cy.get("[data-cy=each-notifications]").eq(2).contains("返信")
  })


  it("通知一覧にアクセスすると、自分が返信した質問への他ユーザーからの返信の通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(1).contains("あなたが返信した質問")

    cy.get("[data-cy=each-notifications]").eq(1).contains("返信")
  })

  it("通知一覧にアクセスすると、自分が作成したアンケートへの回答の通知が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたのアンケートに回答しました")
  })

  it("未ログイン状態だと、通知一覧にアクセスするボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=notifications-link-button]").should("not.exist")
  })

})

describe("通知のリンク確認", () => {

  it("レビューに対するいいね通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(8).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("レビューに対するいいね通知の「あなたのレビュー」をクリックすると、対象のレビュー詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(8).contains("あなたのレビュー").click()

    cy.contains("レビュー詳細")

    cy.contains("通知作成用レビュー1")
  })

  it("質問に対するいいね通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(7).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("質問に対するいいね通知の「あなたの質問」をクリックすると、対象の質問詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(7).contains("あなたの質問").click()

    cy.contains("質問詳細")

    cy.contains("通知作成用質問1")
  })

  it("返信に対するいいね通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(6).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("返信に対するいいね通知の「あなたの返信」をクリックすると、対象の返信詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(6).contains("あなたの返信").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "通知作成用返信1")
  })

  it("科目別質問に対するいいね通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(5).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("科目別質問に対するいいね通知の「あなたの質問(科目別)」をクリックすると、対象の科目別質問詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(5).contains("あなたの質問(科目別)").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("通知作成用科目別質問1")
  })

  it("科目別返信に対するいいね通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(4).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("科目別返信に対するいいね通知の「あなたの返信(科目別)」をクリックすると、対象の科目別返信詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(4).contains("あなたの返信(科目別)").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=subject-question-reply-detail]").find("textarea").should("have.value", "通知作成用科目別返信1")

  })

  it("アンケートに対するいいね通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(3).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("アンケートに対するいいね通知の「あなたのアンケート」をクリックすると、対象のアンケート詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(3).contains("あなたのアンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("通知作成用アンケート1")
  })

  it("質問に対する返信通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(2).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("質問に対する返信通知の「あなたの質問」をクリックすると、対象の質問詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(2).contains("あなたの質問").click()

    cy.contains("質問詳細")

    cy.contains("通知作成用質問1")
  })

  it("質問に対する返信通知の「返信」をクリックすると、対象の返信詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(2).contains("返信").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "通知作成用返信2")
  })

  it("自分が返信を投稿した質問に対する他ユーザーからの返信通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(1).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("自分が返信を投稿した質問に対する他ユーザーからの返信通知の「あなたが返信した質問」をクリックすると、対象の質問詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(1).contains("あなたが返信した質問").click()

    cy.contains("質問詳細")

    cy.contains("通知作成用質問2")
  })

  it("自分が返信を投稿した質問に対する他ユーザーからの返信通知の「返信」をクリックすると、対象の返信詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(1).find("[data-cy=notification-reply-link]").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=reply-detail]").find("textarea").should("have.value", "通知作成用返信4")
  })

  it("自分のアンケートへの回答通知のユーザー名をクリックすると、アクションをしたユーザーの詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("sample-user1").click()

    cy.contains("プロフィール")

    cy.contains("sample-user1")
  })

  it("自分のアンケートへの回答通知の「あなたのアンケート」をクリックすると、対象のアンケート詳細ページに遷移する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたのアンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("通知作成用アンケート1")
  })

})

describe("通知の作成", () => {

  it("自分のレビューがいいねされると、レビューに対するいいねの通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("通知作成用レビュー1").click()

    cy.contains("レビュー詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").scrollIntoView().click({ force: true })

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたのレビューにいいね!しました")
  })

  it("自分の質問がいいねされると、質問に対するいいねの通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用参考書1").click()

    cy.contains("参考書詳細")

    cy.get(".v-tabs").contains("質問").click()

    cy.contains("通知作成用質問1").click()

    cy.contains("質問詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").scrollIntoView().click({ force: true })

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたの質問にいいね!しました")
  })

  it("自分の返信がいいねされると、返信に対するいいねの通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用参考書1").click()

    cy.contains("参考書詳細")

    cy.get(".v-tabs").contains("質問").click()

    cy.contains("通知作成用質問1").click()

    cy.contains("質問詳細")

    cy.get("[data-cy=each-question-replies]").eq(0).find("textarea").should("have.value", "通知作成用返信1").click()

    cy.contains("返信詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").scrollIntoView().click({ force: true })

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたの返信にいいね!しました")
  })

  it("自分の科目別質問がいいねされると、科目別質問に対するいいねの通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").scrollIntoView().click({ force: true })

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたの質問(科目別)にいいね!しました")
  })

  it("自分の科目別返信がいいねされると、科目別返信に対するいいねの通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.get("[data-cy=each-subject-question-subject-question-replies]").eq(0).find("textarea").should("have.value", "通知作成用科目別返信1").click()

    cy.contains("返信詳細(科目別)")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").scrollIntoView().click({ force: true })

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたの返信(科目別)にいいね!しました")
  })

  it("自分のアンケートがいいねされると、アンケートに対するいいねの通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("進路・大学").click()

    cy.contains("通知作成用アンケート1").click()

    cy.contains("アンケート詳細")

    cy.get("[data-cy=favorite-section]").find("[data-cy=add-favorite-button]").scrollIntoView().click({ force: true })

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたのアンケートにいいね!しました")
  })

  it("自分の質問に返信が投稿されると、質問に対する返信の通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用質問1").click()

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").scrollIntoView().click({ force: true })

    cy.get("[data-cy=create-content-field]").type("通知作成用新規返信1")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("edit-cypress-sample")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたの質問")

    cy.get("[data-cy=each-notifications]").eq(0).contains("返信しました")

    cy.get("[data-cy=each-notifications]").eq(0).contains("通知作成用新規返信1")
  })

  it("自分が返信した質問に返信が投稿されると、質問に対する返信の通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用質問2").click()

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").scrollIntoView().click({ force: true })

    cy.get("[data-cy=create-content-field]").type("通知作成用新規返信2")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("edit-cypress-sample")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたが返信した質問")

    cy.get("[data-cy=each-notifications]").eq(0).contains("返信しました")

    cy.get("[data-cy=each-notifications]").eq(0).contains("通知作成用新規返信2")

  })


  it("自分の科目別質問に返信が投稿されると、科目別質問に対する返信の通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("返信を投稿する").scrollIntoView().click({ force: true })

    cy.get("[data-cy=create-content-field]").type("通知作成用新規科目別返信1")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("edit-cypress-sample")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたの質問")

    cy.get("[data-cy=each-notifications]").eq(0).contains("返信しました")

    cy.get("[data-cy=each-notifications]").eq(0).contains("通知作成用新規科目別返信1")
  })

  it("自分が返信した科目別質問に返信が投稿されると、科目別質問に対する返信の通知が作成される", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用科目別質問2").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("返信を投稿する").scrollIntoView().click({ force: true })

    cy.get("[data-cy=create-content-field]").type("通知作成用新規科目別返信2")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("edit-cypress-sample")

    cy.get("[data-cy=each-notifications]").eq(0).contains("あなたが返信した質問")

    cy.get("[data-cy=each-notifications]").eq(0).contains("返信しました")

    cy.get("[data-cy=each-notifications]").eq(0).contains("通知作成用新規科目別返信2")
  })

  it("自分の質問に自分が返信を投稿すると、通知が作成されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用質問1").click()

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").scrollIntoView().click({ force: true })

    cy.get("[data-cy=create-content-field]").type("通知作成用新規返信3")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("通知作成用新規返信3").should("not.exist")
  })

  it("自分の科目別質問に自分が返信を投稿すると、通知が作成されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("科目別質問一覧").click()

    cy.get("[data-cy=filter-subject-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用科目別質問1").click()

    cy.contains("質問詳細(科目別)")

    cy.contains("返信を投稿する").scrollIntoView().click({ force: true })

    cy.get("[data-cy=create-content-field]").type("通知作成用新規科目別返信3")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.get("[data-cy=each-notifications]").eq(0).contains("通知作成用新規科目別返信3").should("not.exist")
  })



})

describe("新着通知", () => {

  it("未確認の新着通知が存在すると、ヘッダーにマークがつく", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用質問1").click()

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").scrollIntoView().click({ force: true })

    cy.get("[data-cy=create-content-field]").type("通知作成用新規返信4")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").find(".v-badge")
  })

  it("未確認の新着通知を確認すると、ヘッダーのマークが消える", () => {
    cy.login("edit_cypress@cypress.com", "cypress")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("質問一覧").click()

    cy.get("[data-cy=filter-questions-select]").scrollIntoView().click()

    cy.get(".v-menu__content").scrollTo("bottom").contains("小論文").click()

    cy.contains("通知作成用質問1").click()

    cy.contains("質問詳細")

    cy.contains("返信を投稿する").scrollIntoView().click({ force: true })

    cy.get("[data-cy=create-content-field]").type("通知作成用新規返信5")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("返信の投稿が完了しました")

    cy.get("[data-cy=header-user-menu]").click()

    cy.get("[data-cy=header-user-menu-list]").contains("ログアウト").click()

    cy.login("cypress@cypress.com", "cypress")

    cy.get("[data-cy=notifications-link-button]").find(".v-badge")

    cy.get("[data-cy=notifications-link-button]").click()

    cy.contains("通知一覧")

    cy.visit("/")

    cy.get("[data-cy=notifications-link-button]").find(".v-badge").should("not.exist")
  })




})

