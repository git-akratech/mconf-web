require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AttachmentsController do
  
  include ActionController::AuthenticationTestHelper
  
  integrate_views
    
  before(:all) do
    #the superuser
    @superuser = Factory(:superuser)
    #a private space and three users in that space
    @private_space = Factory(:private_space)
    @private_space2 = Factory(:private_space_with_repository)
    @admin = Factory(:admin_performance, :stage => @private_space).agent
    @admin2 = Factory(:admin_performance, :stage => @private_space2).agent
    @user = Factory(:user_performance, :stage => @private_space).agent
    @user_space2 =  Factory(:user_performance, :stage => @private_space2).agent
    @invited = Factory(:invited_performance, :stage => @private_space).agent
    #a public space
    @public_space = Factory(:public_space)
   
  end
   after(:all) do 
    #remove all the stuff created
    @superuser.destroy
    @private_space.destroy
    @private_space2.destroy
    @admin.destroy
    @user.destroy
    @invited.destroy
    @public_space.destroy   
  end
   describe "A Superadmin" do
    before(:each) do
      login_as(@superuser)
    end
   
   it "should be able to see space repository" do
       get :index, :space_id => @private_space.to_param
       assert_response 200
       response.should render_template("attachments/index.html.erb")
   end
      
   
  end

  describe "The admin of a space" do
   
    it "should be able to delete attachments in his space repository" do  
      login_as(@admin2)
      @attachment = Factory(:attachment,:space => @private_space2,:author => @user_space2)
      delete :destroy ,:id => @attachment, :space_id => @private_space2.to_param
      assert_nil Attachment.find_by_id(@attachment.id) 
    end
    it "should not be able to see space repository if it is not enabled" do
      login_as(@admin)
      get :index, :space_id => @private_space.to_param
      assert_response 403      
    end
    it "should be able to see space repository if it is enabled" do
      login_as(@admin2)
      get :index, :space_id => @private_space2.to_param
      assert_response 200     
      response.should render_template("attachments/index.html.erb")
    end
    it"should be able to show attachments in his space repository"do
      login_as(@admin2)
      @attachment = Factory(:attachment,:space => @private_space2,:author => @user_space2)
      get :show, :space_id => @private_space2.to_param, :id => @attachment.to_param
      assert_response 200                  
    end
    it"should be able to create a new version of an attachment"do
      login_as(@admin2)
       @attachment = Factory(:attachment,:space => @private_space2,:author => @user_space2)
      put :update, :space_id => @private_space2.to_param, :id=>@attachment.id ,:attachment => Factory.attributes_for(:attachment)
    end
  end
# 
# 
  describe "A logged user" do  
   
    
   it "should not be able to delete his own attachment" do     
      login_as(@user_space2)
      @attachment = Factory(:attachment,:space => @private_space2,:author => @user_space2)
      delete :destroy ,:id => @attachment, :space_id => @private_space2.to_param
      #(Attachment.find_by_id(@attachment.id)).should_not_be_nil
      assert_response 403
    end
    
  end

 end