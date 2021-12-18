/* TypeScript file generated from XStateFunctor.res by genType. */
/* eslint-disable import/first */


// tslint:disable-next-line:interface-over-type-literal
export type stateNode<state,event> = 
    { tag: "State"; value: { readonly name: state; readonly on: Array<[event, state]> } }
  | { tag: "Compound"; value: {
  readonly name: state; 
  readonly children: stateNode<state,event>[]; 
  readonly initial: state
} }
  | { tag: "Final"; value: { readonly name: state } };

// tslint:disable-next-line:interface-over-type-literal
export type stateList<state,event> = stateNode<state,event>[];
