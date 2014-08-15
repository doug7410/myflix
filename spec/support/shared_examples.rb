shared_examples "require log in" do
  it "redirects to the log in page" do
    clear_current_user
    action
    expect(response).to redirect_to sessions_new_path
  end
end

shared_examples "the user is logged in" do
  it "redirects to the correct page" do
    action
    expect(response).to redirect_to redirect_page
  end
end