/**
 * @template TState
 * @template TEvent
 * @param {import('./XStateFunctor.gen').stateList<TState, TEvent>} stateList
 */
function makeStates(stateList) {
  return Object.fromEntries(
    stateList.map((node) => {
      console.log(node);
      const stateName = node.value.name;

      let stateValue;
      switch (node.tag) {
        case 'State':
          stateValue = {
            on: Object.fromEntries(node.value.on),
          };
          break;

        default:
          throw new Error('Unimplemented stateNode type ' + node.tag);
      }

      return [stateName, stateValue];
    })
  );
}

function toMachine(x) {
  console.log(x);
}

module.exports = {
  makeStates,
  toMachine,
};
