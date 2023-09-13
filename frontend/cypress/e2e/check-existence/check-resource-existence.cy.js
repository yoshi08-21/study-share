before(() => {
  cy.exec('cd ../ && cd backend && RAILS_ENV=test bundle exec rake db:reset db:seed')
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

describe("存在しないコンテンツへのアクセスに対するバリデーション", () => {

  it("存在しないユーザーの詳細ページに直接アクセスすると、トップページにリダイレクトしてメッセージが表示される", () => {
    cy.visit("/")

    cy.visit("/users/-1")

    cy.contains("Welcome To StudyShare!")

    cy.contains("存在しないユーザーです")
  })

  it("存在しない参考書の詳細ページに直接アクセスすると、トップページにリダイレクトしてメッセージが表示される", () => {
    cy.visit("/")

    cy.visit("/books/-1")

    cy.contains("Welcome To StudyShare!")

    cy.contains("存在しない参考書です")
  })

  it("存在しないレビューの詳細ページに直接アクセスすると、トップページにリダイレクトしてメッセージが表示される", () => {
    cy.visit("/")

    cy.visit("/books/1/reviews/-1")

    cy.contains("Welcome To StudyShare!")

    cy.contains("存在しないレビューです")
  })

  it("存在しない質問の詳細ページに直接アクセスすると、トップページにリダイレクトしてメッセージが表示される", () => {
    cy.visit("/")

    cy.visit("/books/1/questions/-1")

    cy.contains("Welcome To StudyShare!")

    cy.contains("存在しない質問です")
  })

  it("存在しない返信の詳細ページに直接アクセスすると、トップページにリダイレクトしてメッセージが表示される", () => {
    cy.visit("/")

    cy.visit("/books/1/questions/1/replies/-1")

    cy.contains("Welcome To StudyShare!")

    cy.contains("存在しない返信です")
  })

  it("存在しない科目別質問の詳細ページに直接アクセスすると、トップページにリダイレクトしてメッセージが表示される", () => {
    cy.visit("/")

    cy.visit("/subjectQuestions/-1")

    cy.contains("Welcome To StudyShare!")

    cy.contains("存在しない質問です")
  })

  it("存在しない科目別返信の詳細ページに直接アクセスすると、トップページにリダイレクトしてメッセージが表示される", () => {
    cy.visit("/")

    cy.visit("/subjectQuestions/1/subjectQuestionReplies/-1")

    cy.contains("Welcome To StudyShare!")

    cy.contains("存在しない返信です")
  })

  it("存在しないアンケートの詳細ページに直接アクセスすると、トップページにリダイレクトしてメッセージが表示される", () => {
    cy.visit("/")

    cy.visit("/surveys/-1")

    cy.contains("Welcome To StudyShare!")

    cy.contains("存在しないアンケートです")
  })

})



describe("存在しないページへのアクセスに対するバリデーション", () => {

  it("存在しないページに直接アクセスすると、エラーページにリダイレクトする", () => {
    cy.visit("/")

    cy.visit("/undefined/undifined")

    cy.url().should("include", "/errors/errorPage")

    cy.contains("エラーページ")

    cy.contains("存在しないページです")

    cy.contains("トップページに戻る").click()

    cy.contains("Welcome To StudyShare!")
  })



})
