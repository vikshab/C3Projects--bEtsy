module ProductsHelper

  def retire_helper(product)
    product.retired ? "Reactivate" : "Retire"
  end
end
