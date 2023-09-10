
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



describe("参考書のお気に入り一覧", () => {

  it("3冊の参考書がお気に入りに登録されていると、お気に入り一覧ページに3冊の参考書が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り用参考書1")

    cy.contains("お気に入り用参考書2")

    cy.contains("お気に入り用参考書3")
  })

})

describe("お気に入りの有無の確認", () => {

  it("お気に入りに追加していない参考書の詳細ページにアクセスすると、「お気に入りに追加」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り用参考書4").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り用参考書4")

    cy.contains("お気に入りに追加する")
  })

  it("お気に入りに追加済みの参考書の詳細ページにアクセスすると、「お気に入り削除」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り用参考書1").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り用参考書1")

    cy.contains("お気に入りから削除する")
  })

  it("参考書一覧ページでお気に入りに追加していない参考書に「お気に入り追加」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.get("[data-cy=each-books]").eq(3).contains("お気に入り用参考書4")

    cy.get("[data-cy=each-books]").eq(3).contains("お気に入り追加")


  })

  it("参考書一覧ページでお気に入りに追加済みの参考書に「お気に入り削除」ボタンが表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.get("[data-cy=each-books]").eq(0).contains("お気に入り用参考書1")

    cy.get("[data-cy=each-books]").eq(0).contains("お気に入り削除")
  })

})

describe("参考書のお気に入り登録", () => {

  // お気に入り数の増加とお気に入り一覧への表示は２つのテストに分けたほうがいいそうだ・・・
  it("参考書詳細ページで参考書をお気に入りに登録すると、参考書のお気に入り数が1増加する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り登録用参考書1").scrollIntoView().click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り登録用参考書1")

    cy.get("[data-cy=book-favorite-section]").contains("0")

    cy.contains("お気に入りに追加する").click()

    cy.get("[data-cy=book-favorite-section]").contains("1")

    cy.contains("お気に入りから削除する")
  })

  it("参考書詳細ページで参考書をお気に入りに登録すると、お気に入り一覧に参考書が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り登録用参考書2").should("not.exist")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り登録用参考書2").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り登録用参考書2")

    cy.contains("お気に入りに追加する").click()

    cy.contains("お気に入りから削除する")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り登録用参考書2")
  })


  it("参考書詳細一覧ページで参考書をお気に入りに登録すると、参考書のお気に入り数が1増加する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.get("[data-cy=each-books]").eq(6).contains("お気に入り登録用参考書3")

    cy.get("[data-cy=each-books]").eq(6).find("[data-cy=each-book-favorite-section]").contains("お気に入り")

    cy.get("[data-cy=each-books]").eq(6).find("[data-cy=each-book-favorite-section]").contains("0")

    cy.get("[data-cy=each-books]").eq(6).contains("お気に入り追加").click()

    cy.contains("お気に入りに追加しました")

    cy.get("[data-cy=each-books]").eq(6).find("[data-cy=each-book-favorite-section]").contains("お気に入り")

    cy.get("[data-cy=each-books]").eq(6).find("[data-cy=each-book-favorite-section]").contains("1")

    cy.get("[data-cy=each-books]").eq(6).contains("お気に入り削除")
  })

  it("参考書詳細一覧ページで参考書をお気に入りに登録すると、お気に入り一覧に参考書が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り登録用参考書4").should("not.exist")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.get("[data-cy=each-books]").eq(7).contains("お気に入り登録用参考書4")

    cy.get("[data-cy=each-books]").eq(7).contains("お気に入り追加").click()

    cy.contains("お気に入りに追加しました")

    cy.get("[data-cy=each-books]").eq(7).contains("お気に入り削除")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り登録用参考書4")
  })

})

describe("参考書のお気に入り削除", () => {

  it("参考書詳細ページで参考書をお気に入りから削除すると、参考書のお気に入り数が1減少する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り解除用参考書1").scrollIntoView().click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り解除用参考書1")

    cy.get("[data-cy=book-favorite-section]").contains("1")

    cy.contains("お気に入りから削除する").click()

    cy.contains("お気に入りから削除しました")

    cy.get("[data-cy=book-favorite-section]").contains("0")

    cy.contains("お気に入りに追加する")
  })

  it("参考書詳細ページで参考書をお気に入りから削除すると、お気に入り一覧から参考書が削除される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り解除用参考書2")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.contains("お気に入り解除用参考書2").click()

    cy.contains("参考書詳細")

    cy.contains("お気に入り解除用参考書2")

    cy.contains("お気に入りから削除する").click()

    cy.contains("お気に入りから削除しました")

    cy.contains("お気に入りに追加する")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り解除用参考書2").should("not.exist")
  })

  it("参考書一覧ページで参考書をお気に入りから削除すると、参考書のお気に入り数が1減少する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.get(".v-pagination").contains("2").click()

    cy.get("[data-cy=each-books]").eq(0).contains("お気に入り解除用参考書3")

    cy.get("[data-cy=each-books]").eq(0).find("[data-cy=each-book-favorite-section]").contains("お気に入り")

    cy.get("[data-cy=each-books]").eq(0).find("[data-cy=each-book-favorite-section]").contains("1")

    cy.get("[data-cy=each-books]").eq(0).contains("お気に入り削除").click()

    cy.contains("お気に入りから削除しました")

    cy.get("[data-cy=each-books]").eq(0).find("[data-cy=each-book-favorite-section]").contains("お気に入り")

    cy.get("[data-cy=each-books]").eq(0).find("[data-cy=each-book-favorite-section]").contains("0")

    cy.get("[data-cy=each-books]").eq(0).contains("お気に入り追加")


  })

  it("参考書一覧ページで参考書をお気に入りから削除すると、お気に入り一覧から参考書が削除される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り解除用参考書4")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("参考書一覧").click()

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").scrollTo("bottom").contains("過去問").click()

    cy.get(".v-pagination").contains("2").click()

    cy.get("[data-cy=each-books]").eq(1).contains("お気に入り解除用参考書4")

    cy.get("[data-cy=each-books]").eq(1).contains("お気に入り削除").click()

    cy.contains("お気に入りから削除しました")

    cy.get("[data-cy=each-books]").eq(1).contains("お気に入り追加")

    cy.get("[data-cy=favorites-link-button]").click()

    cy.contains("お気に入り一覧")

    cy.contains("お気に入り解除用参考書4").should("not.exist")
  })

})
