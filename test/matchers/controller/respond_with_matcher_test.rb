require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class RespondWithMatcherTest < ActionController::TestCase # :nodoc:

  context "a controller responding with success" do
    setup do
      @controller = build_response { render :text => "text", :status => 200 }
    end

    should "accept responding with 200" do
      assert_accepts respond_with(200), @controller
    end
    
    should "accept responding with :success" do
      assert_accepts respond_with(:success), @controller
    end
    
    should "reject responding with another status" do
      assert_rejects respond_with(:error), @controller
    end
  end
  
  context "a controller responding with redirect" do
    setup do
      @controller = build_response { redirect_to 'http://example.com', :status => 301 }
    end

    should "accept responding with 301" do
      assert_accepts respond_with(301), @controller
    end
    
    should "accept responding with :redirect" do
      assert_accepts respond_with(:redirect), @controller
    end
    
    should "reject responding with another status" do
      assert_rejects respond_with(:error), @controller
    end
  end
  
  [["a hash", {:action => :example}, {:action => :example}],
  ["a string without protocol",  "/images/screenshot.jpg", "/images/screenshot.jpg"],
  ["a string with protocol", "http://www.rubyonrails.org", "http://www.rubyonrails.org"],
  ["a symbol", :example, {:action => 'example'}]].each do |description, matcher_argument, expected_value|
    context "a controller responding with redirect to a specific location as #{description}" do
      setup do
        @controller = build_response { redirect_to expected_value }
      end
      
      should "accept redirecting to #{matcher_argument}" do
        assert_accepts respond_with(:redirect).to(matcher_argument), @controller
      end
      
      should "reject redirect to another location" do
        assert_rejects respond_with(:redirect).to("http://anotherlocation.org"), @controller
      end
    end
  end
  
  context "a controller responding with missing" do
    setup do
      @controller = build_response { render :text => "text", :status => 404 }
    end

    should "accept responding with 404" do
      assert_accepts respond_with(404), @controller
    end
    
    should "accept responding with :missing" do
      assert_accepts respond_with(:missing), @controller
    end
    
    should "reject responding with another status" do
      assert_rejects respond_with(:success), @controller
    end
  end
  
  context "a controller responding with error" do
    setup do
      @controller = build_response { render :text => "text", :status => 500 }
    end

    should "accept responding with 500" do
      assert_accepts respond_with(500), @controller
    end
    
    should "accept responding with :error" do
      assert_accepts respond_with(:error), @controller
    end
    
    should "reject responding with another status" do
      assert_rejects respond_with(:success), @controller
    end
  end
  
  context "a controller responding with not implemented" do
    setup do
      @controller = build_response { render :text => "text", :status => 501 }
    end

    should "accept responding with 501" do
      assert_accepts respond_with(501), @controller
    end
    
    should "accept responding with :not_implemented" do
      assert_accepts respond_with(:not_implemented), @controller
    end
    
    should "reject responding with another status" do
      assert_rejects respond_with(:success), @controller
    end
  end
  
  context "a controller raising an error" do
    setup do
      @controller = build_response { raise RailsError }
    end

    should "reject responding with any status" do
      assert_rejects respond_with(:success), @controller
    end
  end

end

