class StravaActivityPresenter < Burgundy::Item

  def self.validators_on(args)
    StravaActivity.validators_on(args)
  end

  [:weight_before, :weight_after].each do |attr|
    define_method(attr) do
      helpers.number_with_delimiter(item.send(attr))
    end
  end

end
