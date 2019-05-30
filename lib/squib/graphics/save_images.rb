module Squib
  class Card

    # :nodoc:
    # @api private
    def save_png(batch, scale_box)
      surface = if preprocess_save?(batch)
                  w, h = compute_dimensions(batch.rotate, batch.trim)
                  preprocessed_save(w, h, batch)
                else
                  @cairo_surface
                end
      surface = scaled_surface(surface, scale_box) if scaling?(scale_box)
      write_png(surface, index, batch.dir, batch.prefix, batch.count_format)
    end

    # :nodoc:
    # @api private
    def preprocess_save?(batch)
      batch.rotate != false || batch.trim > 0
    end

    def scaling?(box)
      box.width != @width || box.height != @height
    end

    def compute_dimensions(rotate, trim)
      if rotate
         [ @height - 2 * trim, @width - 2 * trim ]
       else
         [ @width - 2 * trim, @height - 2 * trim ]
       end
    end

    def preprocessed_save(w, h, batch)
      new_cc = Cairo::Context.new(Cairo::ImageSurface.new(w, h))
      trim_radius = batch.trim_radius
      if batch.rotate != false
        new_cc.translate(w * 0.5, h * 0.5)
        new_cc.rotate(batch.angle)
        new_cc.translate(h * -0.5, w * -0.5)
        new_cc.rounded_rectangle(0, 0, h, w, trim_radius, trim_radius)
      else
        new_cc.rounded_rectangle(0, 0, w, h, trim_radius, trim_radius)
      end
      new_cc.clip
      new_cc.set_source(@cairo_surface, -batch.trim, -batch.trim)
      new_cc.paint
      return new_cc.target
    end

    def scaled_surface(surface, box)
      new_cc = Cairo::Context.new(Cairo::ImageSurface.new(box.width, box.height))
      new_cc.scale(
        box.width.to_f / surface.width,
        box.height.to_f / surface.height
      )
      new_cc.set_source(surface)
      new_cc.paint
      return new_cc.target
    end

    def write_png(surface, i, dir, prefix, count_format)
      surface.write_to_png("#{dir}/#{prefix}#{count_format % i}.png")
    end

  end
end
