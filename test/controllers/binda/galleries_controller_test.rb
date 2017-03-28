require 'test_helper'

module Binda
  class GalleriesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @gallery = binda_galleries(:one)
    end

    test "should get index" do
      get galleries_url
      assert_response :success
    end

    test "should get new" do
      get new_gallery_url
      assert_response :success
    end

    test "should create gallery" do
      assert_difference('Gallery.count') do
        post galleries_url, params: { gallery: { name: @gallery.name, slug: @gallery.slug } }
      end

      assert_redirected_to gallery_url(Gallery.last)
    end

    test "should show gallery" do
      get gallery_url(@gallery)
      assert_response :success
    end

    test "should get edit" do
      get edit_gallery_url(@gallery)
      assert_response :success
    end

    test "should update gallery" do
      patch gallery_url(@gallery), params: { gallery: { name: @gallery.name, slug: @gallery.slug } }
      assert_redirected_to gallery_url(@gallery)
    end

    test "should destroy gallery" do
      assert_difference('Gallery.count', -1) do
        delete gallery_url(@gallery)
      end

      assert_redirected_to galleries_url
    end
  end
end
