# React

- Component's props must be defined inline. Avoid having a type definition for a component.
- When react compiler is available, rely on it rather than adding useMemo and memo.
- When creating a function or an object inside a component, if it does not depends on the component's state and property, to make its reference stable, rather that using useState with no exposed setter, just define it outside the component body.
