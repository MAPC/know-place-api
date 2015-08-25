class Aggregator < ActiveRecord::Base

  TYPES = ["bigint", "bit", "bit varying", "boolean", "char",
    "character varying", "character", "varchar", "date",
    "double precision", "integer", "interval", "numeric", "decimal",
    "real", "smallint", "time", "timestamp", "xml"]

  has_and_belongs_to_many :data_points

  validates :name, presence: true, length: {
    minimum: 3, maximum: 140
  }
  validates :operation, presence: true, length: {
    minimum: 10, maximum: 1000
  }
  # validate :valid_operation_syntax
  validates :return_type, presence: true, inclusion: { in: TYPES }
  validate :valid_function_syntax

  def params
    parameters.split(", ").map do |p|
      dir, name, type = p.strip.split(" ")
      {direction: dir, name: name, type: type}
    end
  end

  # def ordered_params
  #   raise NotImplementedError
  # end

  def to_function
    "#{sql_function_name}(#{parameters})"
  end

  def to_function_definition
    """
      CREATE OR REPLACE FUNCTION #{to_function}
      RETURNS #{ return_type } AS
      $$
        #{ operation }
      $$
      LANGUAGE plpgsql VOLATILE NOT LEAKPROOF;

      COMMENT ON FUNCTION public.#{sql_function_name}(IN integer, IN integer)
      IS '#{ sql_comment }';
    """.strip
  end

  private

  def sql_function_name
    "#{sql_function_prefix}_#{name}"
  end

  def sql_function_prefix
    "contrib_kp"
  end

  def sql_comment
    "#{description} #{sql_standard_comment}"
  end

  def sql_standard_comment
    "Contributed by KnowPlace (mapc.org)."
  end

  # This presents a significant challenge, trying to parse the
  # plpgsql on its own, without calling it.

  def valid_function_syntax
    ActiveRecord::Base.connection.execute to_function_definition
  rescue Exception => e
    errors.add :operation,
      "must be valid PostgreSQL syntax. Function definition: \n\n #{to_function_definition.inspect} \n\n\n Error: \n\n #{e}"
  # ensure
  #   ActiveRecord::Base.connection.execute "DROP FUNCTION IF EXISTS #{sql_function_name}"
  end

end
