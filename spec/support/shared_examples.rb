shared_examples "require log in" do
  it "redirects to the log in page" do
    clear_current_user
    action
    expect(response).to redirect_to sessions_new_path
  end
end

shared_examples "requires admin" do
  it "redirects to the home page" do
    set_current_user
    action
    expect(response).to redirect_to home_path
  end
end

shared_examples "tokenable" do
  it "generates a token when the object is created" do
    expect(object.token).to be_present
  end
end  