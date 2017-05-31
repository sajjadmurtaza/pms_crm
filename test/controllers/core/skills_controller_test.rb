require 'test_helper'

class Core::SkillsControllerTest < ActionController::TestCase
  setup do
    @core_skill = core_skills(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:core_skills)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create core_skill" do
    assert_difference('Core::Skill.count') do
      post :create, core_skill: { name: @core_skill.name, skill_type_id: @core_skill.skill_type_id }
    end

    assert_redirected_to core_skill_path(assigns(:core_skill))
  end

  test "should show core_skill" do
    get :show, id: @core_skill
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @core_skill
    assert_response :success
  end

  test "should update core_skill" do
    patch :update, id: @core_skill, core_skill: { name: @core_skill.name, skill_type_id: @core_skill.skill_type_id }
    assert_redirected_to core_skill_path(assigns(:core_skill))
  end

  test "should destroy core_skill" do
    assert_difference('Core::Skill.count', -1) do
      delete :destroy, id: @core_skill
    end

    assert_redirected_to core_skills_path
  end
end
