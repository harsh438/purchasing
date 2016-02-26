class ElementsController < ApplicationController
  def index
    render json: { elements: Element.all.as_json }
  end
end
