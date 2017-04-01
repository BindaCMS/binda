require 'test_helper'

module Binda
  class DatesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @date = binda_dates(:one)
    end

    test "should get index" do
      get dates_url
      assert_response :success
    end

    test "should get new" do
      get new_date_url
      assert_response :success
    end

    test "should create date" do
      assert_difference('Date.count') do
        post dates_url, params: { date: { date: @date.date } }
      end

      assert_redirected_to date_url(Date.last)
    end

    test "should show date" do
      get date_url(@date)
      assert_response :success
    end

    test "should get edit" do
      get edit_date_url(@date)
      assert_response :success
    end

    test "should update date" do
      patch date_url(@date), params: { date: { date: @date.date } }
      assert_redirected_to date_url(@date)
    end

    test "should destroy date" do
      assert_difference('Date.count', -1) do
        delete date_url(@date)
      end

      assert_redirected_to dates_url
    end
  end
end
