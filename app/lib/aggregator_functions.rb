# TODO: Move to /lib

module AggregatorFunctions

  # Round to the number of digits
  R = 2

  def self.sum(values)
    { value: _sum(values).round(R), margin: nil }
  end

  def self.percent(numerators, denominators)
    value = _percent(numerators, denominators)
    { value: value.round(R+2), margin: nil }
  end

  def self.sum_and_moe(values, margins)
    values, margins = MarginSweeper.new(values, margins).sweep
    value  = _sum values
    margin = Math.sqrt( _sum_of_squares(margins) )
    { value: value.round(R), margin: margin.round(R) }
  end

  def self.percent_and_moe(subset, subset_margins, universe, universe_margins)
    subset = AggregatorFunctions.sum_and_moe(subset, subset_margins)
    universe = AggregatorFunctions.sum_and_moe(universe, universe_margins)
    a, b = subset[:value],  universe[:value]  # Values
    c, d = subset[:margin], universe[:margin] # Margins

    value  = _percent(a, b)
    margin = _percent_moe(a, b, c, d)
    { value: value.round(R+2), margin: margin.round(R+2) }
  end

  def self.median(values)
    { value: _median(values), margin: nil }
  end

  # module ClassMethods
  # end

  # module InstanceMethods
  # end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end

  private

    def self._sum(values)
      Array(values).reduce( :+ )
    end

    def self._sum_of_squares(values)
      Array(values).map{ |item| item ** 2 }.reduce(:+)
    end

    def self._percent(numerators, denominators)
       _sum(numerators) / _sum(denominators).to_f
    end

    def self._percent_moe(a, b, c, d)
      return (c/b) if a == b # Write a test case for if a == b (sub = universe)

      under = under_the_root(a, b, c, d)
      return (1/b) * Math.sqrt( _under_the_root(a, b, c, d) ) if under < 0
      (1/b) * Math.sqrt( under )
    end

    def self.under_the_root(a, b, c, d)
      c**2 - ( (a/b)**2 * d**2 )
    end

    def self._under_the_root(a, b, c, d)
      c**2 + ( (a/b)**2 * d**2 )
    end

    # Credit where due:
    # http://stackoverflow.com/questions/2967586/finding-the-highest-lowest-total-average-and-median-from-an-array-in-ruby
    def self._median(arr)
      sorted  = arr.sort
      len     = arr.length
      # TODO We don't need to be so obscure about this.
      median  = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2
    end
end
