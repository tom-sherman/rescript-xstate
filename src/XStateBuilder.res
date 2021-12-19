type transitionConfig<'state> = {target: array<'state>}

type atomic<'state, 'event> = {name: 'state, on: array<('event, array<transitionConfig<'state>>)>}
type final<'state> = {name: 'state}

@genType
type rec stateNode<'state, 'event> = [
  | #State(atomic<'state, 'event>)
  | #Final(final<'state>)
  | #Compound(compound<'state, 'event>)
]
and compound<'state, 'event> = {
  name: 'state,
  states: array<stateNode<'state, 'event>>,
  initial: 'state,
}

let atomic = (state): stateNode<'state, 'event> => #State(state)
let final = (state): stateNode<'state, 'event> => #Final(state)
let compound = (state): stateNode<'state, 'event> => #Compound(state)

type machine
@module("./util") external toMachine: compound<'state, 'event> => machine = "toMachine"

let build = (~id, ~initial) => {
  name: id,
  initial: initial,
  states: [atomic({name: initial, on: []})],
}

// let on = (node: compound<'state, 'event>, event, ~from, ~target) => {
//   ...node,
//   states: node.states->Js.Array2.map(node =>
//     switch node {
//     | #State(state) if state.name === from =>
//       {
//         ...state,
//         on: state.on->Js.Array2.concat([(from, [{target: [target]}])]),
//       }->atomic
//     | #State(state) => atomic(state)
//     | #Final(state) => final(state)
//     | #Compound(state) => compound(state)
//     }
//   ),
// }

// let machine =
//   build(~initial=#idle, ~id=#fetch)->on(#FETCH, ~from=#idle, ~target=#loading)->toMachine
