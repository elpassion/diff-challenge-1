### TODO
- Create repo
- Push our examples

### How to make interfaces in Ruby?

- Module/class with `NotImplementedError`. Easy to document, because all required methods are in one place. Can't use `self.extend(Inteface).inteface_method`, though.
- Do nothing, just create classes with proper methods.
- Create a helper like `expect(UsersDropDown).to implement_interface(DropDownInterface)`
- Include modules at the and of class and raise `NotImplementedError` on include if base class does not implement all methods.

### Questions

- Should we use complicated examples or simple ones?
- Where to put common logic for smaller classes?
- Should we use NotImplementedError?
- Michal's example - should you start project with that? It's difficult to remove AR later.
- Use diagrams to show dependecy direction
- Use Rubocop, use Reek
- When to start using SOLID? At the beginning?
- How strict are you want to be? Just duck typing?
- Where to put Interface documentation?
- Should interfaces have special names? Like `CarInterface`?

### Mistakes to avoid

#### Method names conflicts when using modules

#### Nested inheritance

```ruby
DropDown
DropDown::Users < DropDown
DropDown::Users::Managers < DropDown::Users 
```

### Naming
```ruby
DropDown
DropDown::Users
DropDown::UsersDropDown
DropDownData::Users
```

If implementations  **requires** interface, emphasize it with dir structure. 
In the example below, files in `drop_down` dir requires `drop_down.rb`.
```
/drop_down/teams.rb
/drop_down/users.rb
drop_down.rb
```

If implementations don't require interface (e.g. when interface is being injected into implementation), then there is no need to put them in subdir. 
In the example below, `DropDowns::Data` can be injected with any `DropDowns::Ui` module.
```
/drop_downs/data
/drop_downs/data/users.rb
/drop_downs/ui/base.rb
/drop_downs/ui/nested.rb
```
