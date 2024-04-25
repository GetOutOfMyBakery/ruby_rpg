class AsteroidComponent < Engine::Component
  attr_reader :size

  def initialize(size)
    @size = size
  end

  def self.asteroids
    @asteroids ||= []
  end

  def start
    AsteroidComponent.asteroids << self
  end

  def destroy!
    AsteroidComponent.asteroids.delete(self)
    split if size > 40
    game_object.destroy!
  end

  private

  def split
    3.times do
      Asteroid.new(
        game_object.pos + Vector.new(rand(-50..50), rand(-50..50)),
        rand(360),
        size / 2
      )
    end
  end
end