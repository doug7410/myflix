shared_examples "require_sign_in" do
  it "redirects to the my queue page" do
    set_current_user
    action
    response.should redirect_to my_queue_path
  end
end