require 'test_helper'

module Binda
  class FieldGroupsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @field_group = binda_field_groups(:one)
    end

    test "should get index" do
      get field_groups_url
      assert_response :success
    end

    test "should get new" do
      get new_field_group_url
      assert_response :success
    end

    test "should create field_group" do
      assert_difference('FieldGroup.count') do
        post field_groups_url, params: { field_group: { field_type: @field_group.field_type, name: @field_group.name, position: @field_group.position } }
      end

      assert_redirected_to field_group_url(FieldGroup.last)
    end

    test "should show field_group" do
      get field_group_url(@field_group)
      assert_response :success
    end

    test "should get edit" do
      get edit_field_group_url(@field_group)
      assert_response :success
    end

    test "should update field_group" do
      patch field_group_url(@field_group), params: { field_group: { field_type: @field_group.field_type, name: @field_group.name, position: @field_group.position } }
      assert_redirected_to field_group_url(@field_group)
    end

    test "should destroy field_group" do
      assert_difference('FieldGroup.count', -1) do
        delete field_group_url(@field_group)
      end

      assert_redirected_to field_groups_url
    end
  end
end
