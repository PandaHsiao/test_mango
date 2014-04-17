class BHomeController < ApplicationController
  def index
    @categorys = CategoryColumn.all.entries
  end

  def save_curio

  end
end

