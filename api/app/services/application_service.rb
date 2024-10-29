# frozen_string_literal: true

class ApplicationService
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end

  def result(success:, payload: nil, errors: ActiveModel::Errors.new(self))
    result = Struct.new(:success?, :payload, :errors, :failed?)
    result.new(success, payload, errors, !success)
  end
end
