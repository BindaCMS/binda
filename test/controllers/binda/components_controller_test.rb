require 'test_helper'

module Binda
  class ComponentsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @component = binda_components(:one)
    end

    test "should get index" do
      get components_url
      assert_response :success
    end

    test "should get new" do
      get new_component_url
      assert_response :success
    end

    test "should create component" do
      assert_difference('Component.count') do
        post components_url, params: { component: {  } }
      end

      assert_redirected_to component_url(Component.last)
    end

    test "should show component" do
      get component_url(@component)
      assert_response :success
    end

    test "should get edit" do
      get edit_component_url(@component)
      assert_response :success
    end

    test "should update component" do
      patch component_url(@component), params: { component: {  } }
      assert_redirected_to component_url(@component)
    end

    test "should destroy component" do
      assert_difference('Component.count', -1) do
        delete component_url(@component)
      end

      assert_redirected_to components_url
    end
  end
end
