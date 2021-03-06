require_relative('../db/sql_runner.rb')

class City

  attr_reader :id
  attr_accessor :name, :travelled, :country_id

  def initialize(options)
    @id = options['id'].to_i if options['id'].to_i
    @name = options['name']
    @travelled = options['travelled']
    @country_id = options['country_id'].to_i
  end

  def save ()
    sql = "INSERT INTO cities (name, travelled, country_id)
    VALUES ($1, $2, $3) RETURNING id"
    values = [@name, @travelled, @country_id]
    cities = SqlRunner.run(sql, values).first
    @id = cities['id'].to_i
  end

  def update()
    sql = "UPDATE cities
    SET
    (
      name,
      travelled
      ) = (
        $1, $2
      )
      WHERE id = $3"
    values = [@name, @travelled, @country_id]
    SqlRunner.run(sql, values)
  end

  def gastros
    sql = "SELECT * FROM gastronomies WHERE city_id = $1"
    values = [@id]
    gastro_data = SqlRunner.run(sql, values)
    return gastro_data.map { |gastro| Gastronomy.new(gastro)}
  end

  def self.all()
    sql = "SELECT * FROM cities"
    SqlRunner.run(sql)
  end

  def self.find(id)
    sql = "SELECT * FROM cities WHERE id = $1"
    values = [id.to_i]
    ciudad = SqlRunner.run(sql, values)
    result = City.new(ciudad.first)
  end

  def self.delete_all()
    sql = "DELETE FROM cities"
    SqlRunner.run(sql)
  end

  def self.act_of_god(id)
    sql = "DELETE FROM cities
    WHERE id = $1"
    values = [id.to_i]
    SqlRunner.run(sql, values)
  end


end
