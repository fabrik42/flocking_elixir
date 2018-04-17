const createStage = el => {
  return { el, ctx: el.getContext('2d'), width: el.width, height: el.height };
};

const clearStage = stage => {
  stage.ctx.clearRect(0, 0, stage.width, stage.height);
};

export { createStage, clearStage };
