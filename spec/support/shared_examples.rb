shared_examples "require log in" do
  it "redirects to the log in page" do
    clear_current_user
    action
    expect(response).to redirect_to sessions_new_path
  end
end
