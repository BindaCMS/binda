require 'test_helper'

module Binda
  class FieldSettingsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @field_setting = binda_field_settings(:one)
    end

    test "should get index" do
      get field_settings_url
      assert_response :success
    end

    test "should get new" do
      get new_field_setting_url
      assert_response :success
    end

    test "should create field_setting" do
      assert_difference('FieldSetting.count') do
        post field_settings_url, params: { field_setting: { field_type: @field_setting.field_type, name: @field_setting.name, position: @field_setting.position } }
      end

      assert_redirected_to field_setting_url(FieldSetting.last)
    end

    test "should show field_setting" do
      get field_setting_url(@field_setting)
      assert_response :success
    end

    test "should get edit" do
      get edit_field_setting_url(@field_setting)
      assert_response :success
    end

    test "should update field_setting" do
      patch field_setting_url(@field_setting), params: { field_setting: { field_type: @field_setting.field_type, name: @field_setting.name, position: @field_setting.position } }
      assert_redirected_to field_setting_url(@field_setting)
    end

    test "should destroy field_setting" do
      assert_difference('FieldSetting.count', -1) do
        delete field_setting_url(@field_setting)
      end

      assert_redirected_to field_settings_url
    end
  end
end
