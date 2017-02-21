require 'test_helper'

class FarmListsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get farm_lists_index_url
    assert_response :success
  end

  test "should get edit" do
    get farm_lists_edit_url
    assert_response :success
  end

  test "should get create" do
    get farm_lists_create_url
    assert_response :success
  end

  test "should get update" do
    get farm_lists_update_url
    assert_response :success
  end

  test "should get destroy" do
    get farm_lists_destroy_url
    assert_response :success
  end

end
