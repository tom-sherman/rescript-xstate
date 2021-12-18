@genType
type rec stateNode<'state, 'event> =
  | State({name: 'state, on: array<('event, 'state)>})
  | Compound({name: 'state, children: array<stateNode<'state, 'event>>, initial: 'state})
  | Final({name: 'state})

@genType
type stateList<'state, 'event> = array<stateNode<'state, 'event>>

type stateV<'state> = {value: 'state}

module type MachineDefinition = {
  type context
  type state
  type event
  let id: string
  let initial: state
  let states: stateList<state, event>
}

module type MachineType = (Def: MachineDefinition) =>
{
  type t
  let make: unit => t
  let transition: (t, stateV<Def.state>, Def.event) => stateV<Def.state>
  let initialState: t => stateV<Def.state>
}

module Machine: MachineType = (Def: MachineDefinition) => {
  type t
  include Def
  @module("xstate") external createMachine: 'config => t = "createMachine"
  @module("./util") external makeStates: stateList<state, event> => 'a = "makeStates"
  @send external transitionMachine: (t, stateV<state>, 'event) => stateV<state> = "transition"
  @get external initialState: t => stateV<state> = "initialState"

  let transition = (m, state, event) => transitionMachine(m, state, event)

  let make = () => {
    createMachine({
      "id": id,
      "initial": initial,
      "states": makeStates(states),
    })
  }
}

module FetchMachine = Machine({
  type state = [#idle | #loading | #success | #failure]
  type event = [#FETCH | #RESOLVE | #REJECT | #RETRY]
  type context = {retries: int}

  let id = "fetch"
  let initial = #idle

  let states = [
    State({
      name: #idle,
      on: [(#FETCH, #loading)],
    }),
    State({
      name: #loading,
      on: [(#RESOLVE, #success), (#REJECT, #failure)],
    }),
    Final({
      name: #success,
    }),
    State({
      name: #failure,
      on: [(#RETRY, #loading)],
    }),
  ]
})

@module("./util") external makeStates: stateList<'state, 'event> => 'a = "makeStates"

makeStates([
  State({
    name: #idle,
    on: [(#FETCH, #loading)],
  }),
])

// open FetchMachine
// let machine = make()
// let currentState = machine->initialState
// let nextState = machine->transition(currentState, #FETCH)
// Js.log(nextState.value)
