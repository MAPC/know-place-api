# TODO: Move to /lib

class MarginSweeper

  # TODO: Add documentation on inputs and outputs, with a robust example.

  def initialize(values, margins)
    @values  = values
    @margins = margins
  end

  def sweep
    # Just return if it doesn't need to be swept.
    return [@values, @margins] unless needs_sweep?

    collection = @values.zip @margins
    zeros, collection = separate_zeros(collection)

    # Find the zero value with the biggest margin of error, then
    zero_to_keep = zeros.max_by {|value, margin| margin}
    # pop that zero back into the front of the collection.
    collection.unshift zero_to_keep
    # Split array back into values and margins
    collection.transpose
  end

  # Check if there are duplicate zero values.
  def needs_sweep?
    @values.count{ |value| value == 0 } > 1
  end

  # Capture zero values, then delete from the main collection.
  def separate_zeros(collection)
    zeros = collection.select {|value, margin| value == 0 }
    collection.reject!{|value, margin| value == 0 }
    return [zeros, collection]
  end

end
