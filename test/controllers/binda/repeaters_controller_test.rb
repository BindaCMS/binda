require 'test_helper'

module Binda
  class RepeatersControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @repeater = binda_repeaters(:one)
    end

    test "should get index" do
      get repeaters_url
      assert_response :success
    end

    test "should get new" do
      get new_repeater_url
      assert_response :success
    end

    test "should create repeater" do
      assert_difference('Repeater.count') do
        post repeaters_url, params: { repeater: { name: @repeater.name, slug: @repeater.slug } }
      end

      assert_redirected_to repeater_url(Repeater.last)
    end

    test "should show repeater" do
      get repeater_url(@repeater)
      assert_response :success
    end

    test "should get edit" do
      get edit_repeater_url(@repeater)
      assert_response :success
    end

    test "should update repeater" do
      patch repeater_url(@repeater), params: { repeater: { name: @repeater.name, slug: @repeater.slug } }
      assert_redirected_to repeater_url(@repeater)
    end

    test "should destroy repeater" do
      assert_difference('Repeater.count', -1) do
        delete repeater_url(@repeater)
      end

      assert_redirected_to repeaters_url
    end
  end
end
