require 'test_helper'

module Binda
  class CategoriesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @category = binda_categories(:one)
    end

    test "should get index" do
      get categories_url
      assert_response :success
    end

    test "should get new" do
      get new_category_url
      assert_response :success
    end

    test "should create category" do
      assert_difference('Category.count') do
        post categories_url, params: { category: { name: @category.name, slug: @category.slug, structure_id: @category.structure_id } }
      end

      assert_redirected_to category_url(Category.last)
    end

    test "should show category" do
      get category_url(@category)
      assert_response :success
    end

    test "should get edit" do
      get edit_category_url(@category)
      assert_response :success
    end

    test "should update category" do
      patch category_url(@category), params: { category: { name: @category.name, slug: @category.slug, structure_id: @category.structure_id } }
      assert_redirected_to category_url(@category)
    end

    test "should destroy category" do
      assert_difference('Category.count', -1) do
        delete category_url(@category)
      end

      assert_redirected_to categories_url
    end
  end
end
