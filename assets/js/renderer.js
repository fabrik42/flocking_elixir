const boidPerceptionRadius = (boid, { ctx }) => {
  var circle = new Path2D();
  circle.arc(
    boid.position.x,
    boid.position.y,
    boid.perception_radius,
    0,
    2 * Math.PI,
    false
  );
  ctx.stroke(circle);
};

const heading = vector => {
  var angle = Math.atan2(-vector.y, vector.x);
  return -1 * angle;
};

const rgbaFromObject = (obj, alpha) => {
  return ['rgba(' + obj.r, obj.g, obj.b, alpha + ')'].join(',');
};

const renderBoid = (boid, { ctx }) => {
  ctx.save();

  ctx.translate(boid.position.x + 0.5, boid.position.y + 0.5);
  ctx.rotate(heading(boid.velocity));

  const width = boid.size;
  const height = boid.size / 2;

  var path = new Path2D();
  path.moveTo(-(width / 2), -(height / 2));
  path.lineTo(-(width / 3), 0);
  path.lineTo(-(width / 2), height / 2);
  path.lineTo(width / 2, 0);
  path.closePath();

  ctx.fillStyle = rgbaFromObject(boid.color, 0.5);
  ctx.strokeStyle = rgbaFromObject(boid.color, 1);
  ctx.fill(path);
  ctx.stroke(path);

  ctx.restore();

  ctx.fillStyle = '#000000';
  ctx.fillRect(boid.position.x - 1, boid.position.y - 1, 2, 2);
  // boidPerceptionRadius(boid, { ctx });
};

export { renderBoid };
