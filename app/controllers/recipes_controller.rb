# Recipes Controller
class RecipesController < ApplicationController
  skip_before_action :require_login, only: :index
  before_action :find_recipe, only: %i[show edit edit_instructions edit_ingredients update destroy]
  before_action :set_user, only: %i[edit edit_instructions edit_ingredients update destroy]

  def index
    @recipes = Recipe.all.order('created_at DESC')
  end

  # Method for custom route
  def user_recipes
    @recipes = Recipe.all
  end

  def show; end

  def new
    @recipe = Recipe.new
    6.times { @recipe.instructions.build }
    8.times { @recipe.ingredients.build }
  end

  def create
    @recipe = current_user.recipes.new(recipe_params)

    if @recipe.save
      redirect_to @recipe
    else
      render :new
    end
  end

  def edit
    @recipe.instructions.build
    @recipe.ingredients.build
  end

  # Method for nested form
  def edit_instructions
    3.times { @recipe.instructions.build }
  end

  # Method for nested form

  def edit_ingredients
    3.times { @recipe.ingredients.build }
  end

  def update
    if @recipe.update(recipe_params)
      flash[:success] = 'Recipe updated'
      redirect_to @recipe
    else
      render :edit
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :description,
                                   instructions_attributes: %i[id step _destroy],
                                   ingredients_attributes: %i[id name _destroy])
  end

  def find_recipe
    @recipe = Recipe.find(params[:id])
  end

  def set_user
    unless equal_with_current_user?(@recipe.user)
      flash[:danger] = 'Wrong User'
      redirect_to(root_path)
    end
  end
end
