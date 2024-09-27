module UserAssets
  def self.get_valid_user_object(
    nickname: "Nickname",                                
    name: "John",
    surname: "Doe",
    password: "qwerty123",
    password_confirmation: "qwerty123"
  )
    return User.new({
      nickname: nickname,
      name: name,
      surname: surname,
      password: password,
      password_confirmation: password_confirmation
    })
  end
end