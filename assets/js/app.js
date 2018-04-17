import 'phoenix_html';
import $ from 'jquery';
import { Socket } from 'phoenix';
import { createStage, clearStage } from './stage';
import { renderBoid } from './renderer';

const socket = new Socket('/socket', { params: { token: 'Hello' } });
const stage = createStage(document.getElementById('canvas'));

socket.connect();
socket.onError(() => console.log('there was an error with the connection!'));
socket.onClose(() => console.log('the connection dropped'));

const channel = socket.channel('boids', {});

channel.on('boids_update', payload => {
  console.info('boids update');
  console.dir(payload);
});

channel.on('world_state', state => {
  clearStage(stage);
  state.boids.forEach(boid => renderBoid(boid, stage));
});

channel
  .join()
  .receive('ok', resp => {
    console.log('Joined successfully', resp);
  })
  .receive('error', resp => {
    console.log('Unable to join', resp);
  });

$('input[type="range"]').on('input', function() {
  const el = $(this);
  const name = el.data('setting');
  const val = parseInt(el.val(), 10);
  const params = {};
  params[name] = val;

  channel.push('update_settings', params);
});

window.$ = $;
window.channel = channel;

export default socket;
