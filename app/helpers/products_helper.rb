module ProductsHelper
  def retire_product_text(product)
    "#{ product.retired ? "Reactivate" : "Retire" } this Product"
  end
end
