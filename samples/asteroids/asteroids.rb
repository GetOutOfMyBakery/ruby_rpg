require_relative "../../src/engine/engine"

Engine.load(File.dirname(__FILE__))

Engine.start(
  title: 'Asteroids',
  width: 1920, height: 1080,
  background: 'navy',
  fullscreen: true
) do
  Engine::GameObject.new(
    "Ship",
    pos: { x: 300, y: 300 },
    components:
      [ShipEngine.new,
       Gun.new,
       Engine::TriangleRenderer.new(
         { x: 0, y: 20 },
         { x: -20, y: -40 },
         { x: 20, y: -40 },
         { r: 1, g: 0, b: 0 }
       )]
  )
end