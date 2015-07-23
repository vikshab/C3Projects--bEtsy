module ProductsHelper
  def retire_product_text(product)
    "#{ product.retired ? "Retire" : "Reactivate" } this Product" # FIXME: #retire_product_text spec
  end
end
