module AggregatorFunctions

  # Round to the number of digits
  R = 2

  def self.sum(values)
    { value: _sum(values).round(R), margin: nil }
  end

  def self.percent(numerators, denominators)
    value = _percent(numerators, denominators)
    { value: value.round(R), margin: nil }
  end

  def self.sum_and_moe(values, margins)
    # puts "\n\nv: #{values}, m: #{margins}\n\n"
    values, margins = MarginSweeper.new(values, margins).sweep
    value  = _sum values
    margin = Math.sqrt( _sum_of_squares(margins) )
    { value: value.round(R), margin: margin.round(R) }
  end

  def self.percent_and_moe(universe, universe_margins, subset, subset_margins)
    uni, uni_m = MarginSweeper.new(universe, universe_margins).sweep
    sub, sub_m = MarginSweeper.new(subset,   subset_margins).sweep

    value  = _percent(uni, sub)
    margin = _percent_moe(uni, uni_m, sub, sub_m)
    { value: value.round(R), margin: margin.round(R) }
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

    def self._percent_moe(universe, universe_margins, subset, subset_margins)
      raise NotImplementedError
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