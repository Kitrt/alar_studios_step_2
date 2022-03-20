import inside from "point-in-polygon";

drawStar = ({ctx, coordinateX, coordinateY, spikes, outerRadius, innerRadius}) ->
  coords = [];
  rotate = Math.PI / 2 * 3;
  x = coordinateX;
  y = coordinateY;
  step = Math.PI / spikes;

  ctx.beginPath();
  ctx.moveTo(coordinateX, coordinateY - outerRadius);

  for [0...spikes]
    x = coordinateX + Math.cos(rotate) * outerRadius;
    y = coordinateY + Math.sin(rotate) * outerRadius;
    ctx.lineTo(x, y);
    coords.push([x, y]);
    rotate += step;

    x = coordinateX + Math.cos(rotate) * innerRadius;
    y = coordinateY + Math.sin(rotate) * innerRadius;
    ctx.lineTo(x, y);
    coords.push([x, y]);
    rotate += step;

  ctx.lineTo(coordinateX, coordinateY - outerRadius);
  ctx.closePath();
  ctx.stroke();
  ctx.fill();

  return coords;

initiationSmallCanvas = (color = "white") ->
  canvasSmall = document.querySelector("#canvas-small");
  canvasSmallCtx = canvasSmall.getContext("2d");

  canvasSmallCtx.fillStyle = color;
  canvasSmallCtx.fillRect(0, 0, canvasSmall.clientWidth, canvasSmall.clientHeight);

initiationBigCanvas = () ->
  canvasBig = document.querySelector("#canvas-big");
  canvasBigCtx = canvasBig.getContext("2d");

  colorsStar = ["red", "blue", "green", "yellow", "black"];
  coordinateStars = [];
  spikes = 5;
  countStars = 5;
  spaceBetweenFigure = 20;
  offsetLeft = spaceBetweenFigure;

  canvasBigCtx.globalAlpha = 0.7;
  canvasBigCtx.lineWidth = 1;

  sizeFigure = (canvasBig.offsetWidth - (offsetLeft * (countStars + 1))) / countStars;
  outerRadius = sizeFigure / 2;
  innerRadius = outerRadius / 2;

  for i in [0...countStars]
    if i == 0
      offsetLeft += outerRadius;
    else
      offsetLeft += spaceBetweenFigure + sizeFigure;

    canvasBigCtx.strokeStyle = colorsStar[i] || "white";
    canvasBigCtx.fillStyle = colorsStar[i] || "white";

    props = {
      ctx: canvasBigCtx,
      coordinateX: offsetLeft,
      coordinateY: outerRadius + spaceBetweenFigure,
      spikes, outerRadius, innerRadius
    };

    coordinateStars.push(drawStar(props));

  canvasBig.addEventListener("click", (event) ->
    x = event.offsetX;
    y = event.offsetY;

    for key, itemCoordinate of coordinateStars
      if inside([x, y], itemCoordinate)
        return initiationSmallCanvas(colorsStar[key]);

    initiationSmallCanvas();
  );

initiationBigCanvas();
