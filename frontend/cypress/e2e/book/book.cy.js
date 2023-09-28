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

describe("参考書一覧", () => {

  it("参考書が3冊登録されている状態で参考書一覧にアクセスすると、3冊の参考書が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1")

    cy.contains("サンプル参考書2")

    cy.contains("サンプル参考書3")
  })

})

describe("参考書の検索機能", () => {

  context("参考書名で検索", () => {

    it("参考書一覧ページで参考書を参考書名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=search-books-field]").type("日本の歴史1")

      cy.get("[data-cy=search-books-button]").click({ force: true })

      cy.contains("検索結果1件")

      cy.contains("日本の歴史1")
    })

    it("参考書一覧ページで参考書を参考書名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=search-books-field]").type("日本の歴史")

      cy.get("[data-cy=search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("特別ヘッダーの検索バーで参考書を参考書名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=header-search-books-field]").type("日本の歴史1")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果1件")

      cy.contains("日本の歴史1")
    })

    it("特別ヘッダーの検索バーで参考書を参考書名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=header-search-books-field]").type("日本の歴史")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("通常ヘッダーの検索バーで参考書を参考書名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=header-search-books-field]").type("日本の歴史1")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果1件")

      cy.contains("日本の歴史1")
    })

    it("通常ヘッダーの検索バーで参考書を参考書名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=header-search-books-field]").type("日本の歴史")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

  })

  context("参考書の著者名で検索", () => {

    it("参考書一覧ページで参考書を著者名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=search-books-field]").type("日本史一郎")

      cy.get("[data-cy=search-books-button]").click({ force: true })

      cy.contains("検索結果1件")

      cy.contains("日本の歴史1")
    })

    it("参考書一覧ページで参考書を著者名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=search-books-field]").type("郎")

      cy.get("[data-cy=search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("特別ヘッダーの検索バーで参考書を著者名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=header-search-books-field]").type("日本史一郎")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果1件")

      cy.contains("日本の歴史1")
    })

    it("特別ヘッダーの検索バーで参考書を著者名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=header-search-books-field]").type("郎")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("通常ヘッダーの検索バーで参考書を著者名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=header-search-books-field]").type("日本史一郎")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果1件")

      cy.contains("日本の歴史1")
    })

    it("通常ヘッダーの検索バーで参考書を著者名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=header-search-books-field]").type("郎")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })


  })

  context("参考書の出版社名で検索", () => {

    it("参考書一覧ページで参考書を出版社名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=search-books-field]").type("日本出版")

      cy.get("[data-cy=search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("参考書一覧ページで参考書を出版社名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=search-books-field]").type("本出版")

      cy.get("[data-cy=search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("特別ヘッダーの検索バーで参考書を出版社名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=header-search-books-field]").type("日本出版")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("特別ヘッダーの検索バーで参考書を出版社名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=header-search-books-field]").type("本出版")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("通常ヘッダーの検索バーで参考書を出版社名で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=header-search-books-field]").type("日本出版")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("通常ヘッダーの検索バーで参考書を出版社名で検索すると、キーワードが部分一致する参考書が表示される", () => {
      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=header-search-books-field]").type("本出版")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })


  })

  context("参考書の科目で検索", () => {

    it("参考書一覧ページで参考書を科目で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=search-books-field]").type("日本史")

      cy.get("[data-cy=search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })

    it("特別ヘッダーの検索バーで参考書を科目で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=header-search-books-field]").type("日本史")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })


    it("通常ヘッダーの検索バーで参考書を科目で検索すると、キーワードが完全一致する参考書が表示される", () => {
      cy.visit("/")

      cy.get("[data-cy=menu-button]").click({ force: true })

      cy.contains("参考書一覧").click({ force: true })

      cy.get("[data-cy=header-search-books-field]").type("日本史")

      cy.get("[data-cy=header-search-books-button]").click({ force: true })

      cy.contains("検索結果")

      cy.contains("日本の歴史1")

      cy.contains("日本の歴史2")

      cy.contains("日本の歴史3")

      cy.contains("日本の歴史4")
    })


  })



})

describe("参考書の並べ替え機能", () => {

  it("参考書を「新着順」で並び替えると、新着順に参考書が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=sort-books-select]").click({ force: true })

    cy.contains("新着順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("通知作成用参考書1")
  })

  it("参考書を「投稿順」で並び替えると、投稿順に参考書が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=sort-books-select]").click({ force: true })

    cy.contains("投稿順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("サンプル参考書1")
  })

  it("参考書を「評価が高い順」で並び替えると、評価が高い順に参考書が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=sort-books-select]").click({ force: true })

    cy.contains("評価が高い順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("日本の歴史1")
  })

  it("参考書を「レビューが多い順」で並び替えると、レビューが多い順に参考書が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=sort-books-select]").click({ force: true })

    cy.contains("レビューが多い順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("日本の歴史2")

  })

  it("参考書を「お気に入り登録数が多い順」で並び替えると、お気に入り登録数が多い順に参考書が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=sort-books-select]").click({ force: true })

    cy.contains("お気に入り登録数が多い順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("日本の歴史3")
  })

})

describe("参考書の絞り込み機能", () => {

  it("参考書を「日本史」の科目で絞り込むと、科目が日本史の参考書のみが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").click({ force: true })

    cy.get(".v-menu__content").contains("日本史").click({ force: true })

    cy.contains("日本の歴史1")

    cy.contains("日本の歴史2")

    cy.contains("日本の歴史3")

    cy.contains("日本の歴史4")

    cy.contains("サンプル参考書").should("not.exist")
  })

})

describe("参考書の絞り込み=>並び替え機能", () => {

  it("参考書を「日本史」の科目で絞り込み、「新着順」で並び替えると、科目が日本史の参考書のみが新着順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("日本史").click({ force: true })

    cy.get("[data-cy=sort-books-select]").scrollIntoView().click({ force: true })

    cy.contains("新着順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("日本の歴史4")

    cy.contains("サンプル参考書").should("not.exist")
  })

  it("参考書を「日本史」の科目で絞り込み、「投稿順」で並び替えると、科目が日本史の参考書のみが投稿順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("日本史").click({ force: true })

    cy.get("[data-cy=sort-books-select]").scrollIntoView().click({ force: true })

    cy.contains("投稿順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("日本の歴史1")

    cy.contains("サンプル参考書").should("not.exist")
  })

  it("参考書を「日本史」の科目で絞り込み、「評価が高い順」で並び替えると、科目が日本史の参考書のみが評価が高い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("日本史").click({ force: true })

    cy.get("[data-cy=sort-books-select]").scrollIntoView().click({ force: true })

    cy.contains("評価が高い順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("日本の歴史1")

    cy.contains("サンプル参考書").should("not.exist")
  })

  it("参考書を「日本史」の科目で絞り込み、「レビューが多い順」で並び替えると、科目が日本史の参考書のみがレビューが多い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("日本史").click({ force: true })

    cy.get("[data-cy=sort-books-select]").scrollIntoView().click({ force: true })

    cy.contains("レビューが多い順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("日本の歴史2")

    cy.contains("サンプル参考書").should("not.exist")
  })

  it("参考書を「日本史」の科目で絞り込み、「お気に入り登録数が多い順」で並び替えると、科目が日本史の参考書のみがお気に入り登録数が多い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.get("[data-cy=filter-books-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("日本史").click({ force: true })

    cy.get("[data-cy=sort-books-select]").scrollIntoView().click({ force: true })

    cy.contains("お気に入り登録数が多い順").click({ force: true })

    cy.get("[data-cy=each-books]").first().contains("日本の歴史3")

    cy.contains("サンプル参考書").should("not.exist")
  })

})



describe("参考書詳細", () => {

  it("参考書詳細ページにアクセスすると、参考書の詳細情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

    cy.contains("サンプル参考書1")

    cy.contains("現代文")

    cy.contains("サンプル著者1")

    cy.contains("サンプル出版社1")

    cy.get("textarea").should("have.value", "サンプル参考書1の説明文")

    cy.get("[data-cy=book-review-section]").contains("レビュー")

    cy.get("[data-cy=book-review-section]").contains("3件")

    cy.get("[data-cy=book-question-section]").contains("質問")

    cy.get("[data-cy=book-question-section]").contains("3件")

    cy.get("[data-cy=book-favorite-section]").contains("お気に入り")

    cy.get("[data-cy=book-favorite-section]").contains("1")
  })

})


describe("参考書登録", () => {

  it("ログイン状態で参考書を登録すると、参考書の登録に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("新しい参考書を登録する").click({ force: true })

    cy.contains("参考書を登録する")

    cy.contains("科目を選択する(必須)").click({ force: true })

    cy.get("[data-cy=select-subject-group]").find(".v-label").first().click({ force: true })

    cy.get("[data-cy=close-select-subject-dialog]").click({ force: true })

    cy.contains("選択された科目:現代文")

    cy.get("[data-cy=create-name-field]").type("新規サンプル参考書")

    cy.get("[data-cy=create-author-field]").type("新規サンプル著者")

    cy.get("[data-cy=create-publisher-field]").type("新規サンプル出版社")

    cy.get("[data-cy=create-description-field]").type("新規サンプル説明文")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("参考書の登録が完了しました")

    cy.contains("新規サンプル参考書")

    cy.contains("新規サンプル著者")

    cy.contains("新規サンプル出版社")

    cy.contains("現代文")

    cy.get("textarea").should("have.value", "新規サンプル説明文")
  })

  it("ログイン状態で参考書をGoogle Books APIで登録すると、参考書の登録に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("新しい参考書を登録する").click({ force: true })

    cy.contains("参考書を登録する")

    cy.contains("登録する参考書を検索する").click({ force: true })

    cy.get("[data-cy=google-books-api-search-books]").type("国語")

    cy.get("[data-cy=google-books-api-search-button]").click({ force: true })

    cy.get("[data-cy=searched-books]").last().find("[data-cy=add-book]").click({ force: true })

    cy.contains("科目を選択する(必須)").click({ force: true })

    cy.get("[data-cy=select-subject-group]").find(".v-label").first().click({ force: true })

    cy.get("[data-cy=close-select-subject-dialog]").click({ force: true })

    cy.contains("選択された科目:現代文")

    cy.get("[data-cy=submit-book]").click({ force: true })

    cy.contains("参考書の登録が完了しました")

    cy.contains("現代文")

  })

  it("ログイン状態で不正なパラメーターで参考書を登録すると、参考書の登録に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("新しい参考書を登録する").click({ force: true })

    cy.contains("参考書を登録する")

    cy.get("[data-cy=create-name-field]").click({ force: true }).blur()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=create-author-field]").click({ force: true }).blur()

    cy.contains("著者を入力してください")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("参考書を登録できませんでした")

  })

  it("未ログイン状態で参考書を登録すると、ログインページにリダイレクトする", () => {
    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("新しい参考書を登録する").click({ force: true })

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")

  })

})

describe("参考書編集", () => {

  it("ログイン状態で自分が投稿した参考書を編集すると、参考書の編集に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書1").should("be.visible").click({ force: true })

    cy.contains("サンプル参考書1")

    cy.contains("サンプル著者1")

    cy.contains("サンプル出版社1")

    cy.contains("現代文")

    cy.get("textarea").should("have.value", "サンプル参考書1の説明文")

    cy.contains("編集する").click({ force: true })

    cy.contains("科目を選択する(必須)").click({ force: true })

    cy.get("[data-cy=select-subject-group]").find(".v-label").eq(1).click({ force: true })

    cy.get("[data-cy=close-select-subject-dialog]").click({ force: true })

    cy.contains("選択された科目:古文")

    cy.get("[data-cy=edit-name-field]").clear().type("編集後サンプル参考書")

    cy.get("[data-cy=edit-author-field]").clear().type("編集後サンプル著者")

    cy.get("[data-cy=edit-publisher-field]").clear().type("編集後サンプル出版社")

    cy.get("[data-cy=edit-description-field]").clear().type("編集後サンプル説明文")

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("参考書の編集が完了しました")

    cy.contains("編集後サンプル参考書")

    cy.contains("編集後サンプル著者")

    cy.contains("編集後サンプル出版社")

    cy.contains("古文")

    cy.get("textarea").should("have.value", "編集後サンプル説明文")
  })

  it("ログイン状態で他人が投稿した参考書詳細ページにアクセスすると、参考書編集ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書4").scrollIntoView()

    cy.contains("サンプル参考書4").click({ force: true })

    cy.contains("サンプル参考書4")

    cy.contains("編集する").should("not.exist")
  })

  it("ログイン状態で不正なパラメーターで参考書を編集すると、参考書の編集に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書2").scrollIntoView()

    cy.contains("サンプル参考書2").click({ force: true })

    cy.get("[data-cy=edit-book-button]").click({force: true})

    cy.get("[data-cy=edit-name-field]").clear()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=edit-author-field]").clear()

    cy.contains("著者を入力してください")

    cy.get("[data-cy=edit-publisher-field]").clear()

    cy.get("[data-cy=edit-description-field]").clear()

    cy.get("[data-cy=submit-button]").click({ force: true })

    cy.contains("参考書を編集できませんでした")
  })

  it("未ログイン状態だと、参考書編集ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").should("be.visible").click({ force: true })

    cy.contains("サンプル参考書2").scrollIntoView()

    cy.contains("サンプル参考書2").click({ force: true })

    cy.contains("編集する").should("not.exist")
  })

})

describe("参考書削除", () => {

  it("ログイン状態で自分の参考書を削除すると、参考書の削除に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書2").scrollIntoView()

    cy.contains("サンプル参考書2").click({ force: true })

    cy.get("[data-cy=delete-book-button]").click({force: true})

    cy.contains("参考書を削除しますか？")

    cy.get("[data-cy=delete-confirm-button]").click({ force: true })

    cy.url().should("include", "/allBooks")

    cy.contains("参考書を削除しました")
  })

  it("ログイン状態で他人が投稿した参考書詳細ページにアクセスすると、参考書削除ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書4").scrollIntoView()

    cy.contains("サンプル参考書4").click({ force: true })

    cy.contains("サンプル参考書4")

    cy.contains("削除する").should("not.exist")
  })

  it("未ログイン状態だと、参考書削除ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click({ force: true })

    cy.contains("参考書一覧").click({ force: true })

    cy.contains("サンプル参考書3").scrollIntoView()

    cy.contains("サンプル参考書3").click({ force: true })

    cy.get("[data-cy=delete-book-button]").should("not.exist")
  })

})

