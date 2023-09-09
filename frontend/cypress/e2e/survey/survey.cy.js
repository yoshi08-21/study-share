
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


describe("アンケート一覧", () => {

  it("アンケートが3件投稿されている状態でアンケート一覧ページにアクセスすると、3件のアンケートが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("サンプルアンケートタイトル1")

    cy.contains("サンプルアンケートタイトル2")

    cy.contains("サンプルアンケートタイトル3")
  })

  it("「回答受付中のアンケートのみ表示」にチェックを入れると、締め切り済みのアンケートが一覧に表示されなくなる", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("締め切り済みアンケート")

    cy.get("[data-cy=hide-closed-surveys-switch]").scrollIntoView().click({ force: true })

    cy.contains("締め切り済みアンケート").should("not.exist")
  })
})

describe("アンケートの並べ替え機能", () => {

  it("アンケートを「新着順」で並び替えると、新着順にアンケートが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=sort-surveys-select]").scrollIntoView().click()

    cy.contains("新着順").click()

    cy.get("[data-cy=each-surveys]").first().contains("サンプルアンケートタイトル3")
  })

  it("アンケートを「投稿順」で並び替えると、投稿順にアンケートが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=sort-surveys-select]").scrollIntoView().click()

    cy.contains("投稿順").click()

    cy.get("[data-cy=each-surveys]").first().contains("サンプルアンケートタイトル1")
  })

  it("アンケートを「いいね!が多い順」で並び替えると、いいねが多い順にアンケートが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=sort-surveys-select]").scrollIntoView().click()

    cy.contains("いいね!が多い順").click()

    cy.get("[data-cy=each-surveys]").first().contains("サンプルアンケートタイトル2")
  })

  it("アンケートを「回答が多い順」で並び替えると、回答が多い順にアンケートが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=sort-surveys-select]").scrollIntoView().click()

    cy.contains("回答が多い順").click()

    cy.get("[data-cy=each-surveys]").first().contains("サンプルアンケートタイトル4")
  })

})

describe("アンケートの絞り込み機能", () => {

  it("アンケートを「英文法」のジャンルで絞り込むと、ジャンルが英文法のアンケートのみが表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click()

    cy.get(".v-menu__content").contains("英文法").click()

    cy.contains("英語のアンケート1")

    cy.contains("英語のアンケート2")

    cy.contains("英語のアンケート3")

    cy.contains("英語のアンケート4")

    cy.contains("サンプルアンケート").should("not.exist")
  })

})

describe("アンケートの絞り込み=>並び替え機能", () => {

  it("アンケートを「進路・大学」のジャンルで絞り込み、「新着順」で並び替えると、ジャンルが進路・大学のアンケートのみが新着順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("進路・大学").click()

    cy.get("[data-cy=sort-surveys-select]").scrollIntoView().click({ force: true })

    cy.contains("新着順").click()

    cy.get("[data-cy=each-surveys]").first().contains("進路のアンケート2")

    cy.contains("サンプルジャンル別アンケートタイトル").should("not.exist")
  })

  it("アンケートを「進路・大学」のジャンルで絞り込み、「投稿順」で並び替えると、ジャンルが進路・大学のアンケートのみが投稿順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("進路・大学").click()

    cy.get("[data-cy=sort-surveys-select]").scrollIntoView().click({ force: true })

    cy.contains("投稿順").click()

    cy.get("[data-cy=each-surveys]").first().contains("進路のアンケート1")

    cy.contains("サンプルジャンル別アンケートタイトル").should("not.exist")
  })

  it("アンケートを「進路・大学」のジャンルで絞り込み、「いいね!が多い順」で並び替えると、ジャンルが進路・大学のアンケートのみがいいねが多い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("進路・大学").click()

    cy.get("[data-cy=sort-surveys-select]").scrollIntoView().click({ force: true })

    cy.contains("いいね!が多い順").click()

    cy.get("[data-cy=each-surveys]").first().contains("進路のアンケート3")

    cy.contains("サンプルジャンル別アンケートタイトル").should("not.exist")
  })

  it("アンケートを「進路・大学」のジャンルで絞り込み、「回答が多い順」で並び替えると、ジャンルが進路・大学のアンケートのみが回答が多い順で表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("進路・大学").click()

    cy.get("[data-cy=sort-surveys-select]").scrollIntoView().click({ force: true })

    cy.contains("回答が多い順").click()

    cy.get("[data-cy=each-surveys]").first().contains("進路のアンケート4")

    cy.contains("サンプルジャンル別アンケートタイトル").should("not.exist")
  })

})


describe("アンケート詳細", () => {

  it("アンケート詳細ページにアクセスすると、アンケートの詳細情報が表示される", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("サンプルアンケートタイトル1").click()

    cy.contains("アンケート詳細")

    cy.contains("サンプルアンケートタイトル1")

    cy.contains("ジャンル")

    cy.contains("数学")

    cy.contains("回答受付中")

    cy.get("[data-cy=survey-detail]").find("textarea").should("have.value", "サンプルアンケート本文1")

    cy.get("[data-cy=survey-answer-section]").contains("回答数")

    cy.get("[data-cy=survey-answer-section]").contains("1件")

    cy.get("[data-cy=favorite-section]").contains("いいね!")

    cy.get("[data-cy=favorite-section]").contains("1")

    cy.contains("選択肢1")

    cy.contains("選択肢2")

    cy.contains("選択肢3")

    cy.contains("選択肢4")
  })

  it("アンケートに未回答の場合、アンケートの結果が表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("サンプルアンケートタイトル2").click()

    cy.contains("アンケート詳細")

    cy.contains("サンプルアンケートタイトル2")

    cy.contains("回答受付中")

    cy.contains("アンケート回答結果").should("not.exist")
  })

  it("アンケートに回答済みの場合、自分の回答とアンケートの結果が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("サンプルアンケートタイトル4").click()

    cy.contains("アンケート詳細")

    cy.contains("サンプルアンケートタイトル4")

    cy.contains("回答受付中")

    cy.get(".v-btn--active")

    cy.contains("アンケート回答結果")

    cy.get("[data-cy=option1-result]").contains("選択肢1")

    cy.get("[data-cy=option1-result]").contains("2件")

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

  it("アンケートが締切済みの場合、メッセージとアンケートの結果が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("締め切り済みアンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("締め切り済みアンケート")

    cy.contains("締め切り済み")

    cy.contains("アンケートは締め切られています")

    cy.contains("アンケート回答結果")
  })

  it("アンケートが自分が作成したアンケートだった場合、メッセージとアンケートの結果が表示される", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("サンプルアンケートタイトル1").click()

    cy.contains("アンケート詳細")

    cy.contains("サンプルアンケートタイトル1")

    cy.contains("回答受付中")

    cy.contains("自分のアンケートには回答ができません")

    cy.contains("アンケート回答結果")
  })

  it("未ログイン状態だと、締め切り済みでもアンケートの結果が表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("締め切り済みアンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("締め切り済みアンケート")

    cy.contains("締め切り済み")

    cy.contains("アンケートは締め切られています").should("not.exist")

    cy.contains("アンケート回答結果").should("not.exist")
  })

})


describe("アンケート作成", () => {

  it("ログイン状態でアンケートを作成すると、アンケートの作成に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("新規アンケートを作成する").click()

    cy.contains("新規アンケートを作成する")

    cy.get("[data-cy=select-genre-button]").click()

    cy.contains("社会").click()

    cy.get("[data-cy=create-title-field]").type("新規サンプルアンケートタイトル")

    cy.get("[data-cy=create-content-field]").type("新規サンプルアンケート本文")

    cy.get("[data-cy=create-option1-field]").type("選択肢1")

    cy.get("[data-cy=create-option2-field]").type("選択肢2")

    cy.get("[data-cy=create-option3-field]").type("選択肢3")

    cy.get("[data-cy=create-option4-field]").type("選択肢4")

    cy.get("[data-cy=submit-button]").click()

    cy.contains("内容確認")

    cy.get("[data-cy=confirmation-title-field]").should("have.value", "新規サンプルアンケートタイトル")

    cy.get("[data-cy=confirmation-content-field]").should("have.value", "新規サンプルアンケート本文")

    cy.get("[data-cy=confirmation-option1-field]").should("have.value", "選択肢1")

    cy.get("[data-cy=confirmation-option2-field]").should("have.value", "選択肢2")

    cy.get("[data-cy=confirmation-option3-field]").should("have.value", "選択肢3")

    cy.get("[data-cy=confirmation-option4-field]").should("have.value", "選択肢4")

    cy.get("[data-cy=survey-confirmation-dialog]").find("[data-cy=submit-button]").click()

    cy.contains("アンケートを作成しました")

    cy.contains("アンケート詳細")

    cy.contains("新規サンプルアンケートタイトル")

    cy.contains("ジャンル")

    cy.contains("社会")

    cy.contains("回答受付中")

    cy.get("[data-cy=survey-detail]").find("textarea").should("have.value", "新規サンプルアンケート本文")

    cy.contains("選択肢1")

    cy.contains("選択肢2")

    cy.contains("選択肢3")

    cy.contains("選択肢4")
  })

  it("未ログイン状態でアンケートを作成すると、ログインページにリダイレクトする", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("新規アンケートを作成する").click()

    cy.url().should("include", "/auth/login")

    cy.contains("ログインが必要です")
  })

  it("ログイン状態で不正なパラメーターでアンケートを作成すると、アンケート作成に失敗する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("新規アンケートを作成する").click()

    cy.contains("新規アンケートを作成する")

    cy.get("[data-cy=create-title-field]").click().blur()

    cy.contains("タイトルを入力してください")

    cy.get("[data-cy=create-content-field]").click().blur()

    cy.contains("本文を入力してください")

    cy.get("[data-cy=create-option1-field]").click().blur()

    cy.contains("選択肢を入力してください")

    cy.get("[data-cy=create-option2-field]").click().blur()

    cy.get("[data-cy=submit-button]").click()

    cy.contains("内容確認")

    cy.get("[data-cy=confirmation-title-field]").should("have.value", "")

    cy.get("[data-cy=confirmation-content-field]").should("have.value", "")

    cy.get("[data-cy=confirmation-option1-field]").should("have.value", "")

    cy.get("[data-cy=confirmation-option2-field]").should("have.value", "")

    cy.get("[data-cy=confirmation-option3-field]").should("have.value", "")

    cy.get("[data-cy=confirmation-option4-field]").should("have.value", "")

    cy.get("[data-cy=survey-confirmation-dialog]").find("[data-cy=submit-button]").click()

    cy.contains("アンケートを作成できませんでした")
  })

})

describe("アンケート締め切り", () => {

  it("ログインしている状態で自分が作成したアンケートを締め切ると、アンケートの締切に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.contains("締め切り機能用アンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("締め切り機能用アンケート")

    cy.contains("回答受付中")

    cy.contains("アンケートを締め切る").click()

    cy.contains("アンケートを締め切りますか？")

    cy.get("[data-cy=close-survey-confirmation-button]").click()

    cy.contains("アンケートを締め切りました")

    cy.contains("締め切り済み")
  })

  it("ログインしている状態で他人が作成したアンケートの詳細ページにアクセスすると、アンケート締め切りボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click()

    cy.contains("他ユーザー作成アンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("他ユーザー作成アンケート")

    cy.contains("回答受付中")

    cy.contains("アンケートを締め切る").should("not.exist")
  })

  it("未ログイン状態で自分のアンケートの詳細ページにアクセスすると、アンケート締め切りボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click()

    cy.contains("締め切り機能失敗用アンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("締め切り機能失敗用アンケート")

    cy.contains("回答受付中")

    cy.contains("アンケートを締め切る").should("not.exist")
  })

})

describe("アンケート削除", () => {

  it("ログイン状態で自分のアンケートを削除すると、アンケートの削除に成功する", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.get(".v-tabs").contains("作成したアンケート").click()

    cy.contains("削除用アンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("削除する").click({ force: true })

    cy.contains("アンケートを削除しますか？")

    cy.get("[data-cy=delete-confirm-button]").click()

    cy.contains("アンケートを削除しました")

    cy.visit("/mypage")

    cy.get(".v-tabs").contains("作成したアンケート").click()

    cy.contains("削除用アンケート").should("not.exist")
  })

  it("ログイン状態で他人のアンケート詳細ページにアクセスすると,アンケート削除ボタンが表示されない", () => {
    cy.login("cypress@cypress.com", "cypress")

    cy.contains("プロフィール")

    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click()

    cy.contains("他ユーザー作成アンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("他ユーザー作成アンケート")

    cy.contains("削除する").should("not.exist")
  })


  it("未ログイン状態だと、アンケートの削除ボタンが表示されない", () => {
    cy.visit("/")

    cy.get("[data-cy=menu-button]").click()

    cy.contains("アンケート").click()

    cy.get("[data-cy=filter-surveys-select]").scrollIntoView().click({ force: true })

    cy.get(".v-menu__content").contains("その他").click()

    cy.contains("削除失敗用アンケート").click()

    cy.contains("アンケート詳細")

    cy.contains("削除失敗用アンケート")

    cy.contains("削除する").should("not.exist")
  })

})

