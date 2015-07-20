module ApplicationHelper

  def render_stars(rating)
    output = ''
    if (1..5).include?(rating.to_i)
      rating.to_i.times { output += image_tag('star.png') }
    end
    output.html_safe
  end

  # @categories = Category.all
end
