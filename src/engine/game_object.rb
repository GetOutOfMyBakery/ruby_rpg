class GameObject
  attr_accessor :name, :x, :y, :rotation, :components

  def initialize(name = "Game Object", x: 0, y: 0, rotation: 0, components: [])
    GameObject.object_spawned(self)

    @x = x
    @y = y
    @rotation = rotation
    @name = name
    @components = components
    components.each { |component| component.set_game_object(self) }
    components.each(&:start)
  end

  def local_to_world_coordinate(local_x, local_y)
    angle = Math::PI * @rotation / 180.0
    world_x = @x + local_x * Math.cos(angle) - local_y * Math.sin(angle)
    world_y = @y + local_x * Math.sin(angle) + local_y * Math.cos(angle)
    { x: world_x, y: world_y, z: 0 }
  end

  def self.update_all(delta_time)
    GameObject.objects.each do |object|
      object.components.each { |component| component.update(delta_time) }
    end
  end

  def self.object_spawned(object)
    objects << object
  end

  def self.objects
    @objects ||= []
  end
end
