require 'test_helper'

module Binda
  class AssetsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @asset = binda_assets(:one)
    end

    test "should get index" do
      get assets_url
      assert_response :success
    end

    test "should get new" do
      get new_asset_url
      assert_response :success
    end

    test "should create asset" do
      assert_difference('Asset.count') do
        post assets_url, params: { asset: { image: @asset.image, slug: @asset.slug, title: @asset.title } }
      end

      assert_redirected_to asset_url(Asset.last)
    end

    test "should show asset" do
      get asset_url(@asset)
      assert_response :success
    end

    test "should get edit" do
      get edit_asset_url(@asset)
      assert_response :success
    end

    test "should update asset" do
      patch asset_url(@asset), params: { asset: { image: @asset.image, slug: @asset.slug, title: @asset.title } }
      assert_redirected_to asset_url(@asset)
    end

    test "should destroy asset" do
      assert_difference('Asset.count', -1) do
        delete asset_url(@asset)
      end

      assert_redirected_to assets_url
    end
  end
end
