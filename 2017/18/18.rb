# snd X plays a sound with a frequency equal to the value of X.
# set X Y sets register X to the value of Y.
# add X Y increases register X by the value of Y.
# mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.
# mod X Y sets register X to the remainder of dividing the value contained in register X by the value of Y (that is, it sets X to the result of X modulo Y).
# rcv X recovers the frequency of the last sound played, but only when the value of X is not zero. (If it is zero, the command does nothing.)
# jgz X Y jumps with an offset of the value of Y, but only if the value of X is greater than zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)

$debugging = false

def read_input(name='input')
  file = File.open(name)
  file.read.lines
end

State = Struct.new(:registers, :last_sound) do
  def initialize()
    self.registers = Hash.new(0) # default to 0
    self.last_sound = nil
  end
end

def puts_cmd(str)
  if $debugging
    puts str
  end
end

Value = Struct.new(:arg, :val, :state) do
  def initialize(arg, val, state)
    self.arg = arg
    self.val = val
    self.state = state
  end

  def to_i
    self.val
  end

  def to_s
    if val.is_a?(String)
      "#{arg}: #{val}"
    else
      val.to_s
    end
  end
end

def value_of(arg, state)
  if arg.to_i.to_s == arg
    Value.new(arg, arg.to_i, state)
  else
    Value.new(arg, state.registers[arg], state)
  end
end

def unpack(args, state)
  [args.first, value_of(args.last, state)]
end

def handle_instruction(i, instructions, state)
  instruction = instructions[i]
  cmd, *args = instruction.split
  next_i = i + 1
  ret = nil

  # TODO: probably a better way of defining the schema declaratively
  case cmd 
  when 'snd'
    val = value_of(args.first, state)
    state.last_sound = val.to_i
    puts_cmd "[snd] Sound played at frequency #{val}"
  when 'set'
    reg, val = unpack(args, state)
    orig = state.registers[reg]
    state.registers[reg] = val.to_i
    puts_cmd "[set] Register #{reg} set to #{val} from #{orig || 'null'}"
  when 'add'
    reg, val = unpack(args, state)
    orig = state.registers[reg]
    state.registers[reg] = orig + val.to_i
    puts_cmd "[add] Register #{reg}: #{orig} + #{val} = #{state.registers[reg]}"
  when 'mul'
    reg, val = unpack(args, state)
    orig = state.registers[reg]
    state.registers[reg] = orig * val.to_i
    puts_cmd "[mul] Register #{reg}: #{orig} * #{val} = #{state.registers[reg]}"
  when 'mod'
    reg, val = unpack(args, state)
    orig = state.registers[reg]
    state.registers[reg] = orig % val.to_i
    puts_cmd "[mod] Register #{reg}: #{orig} % #{val} = #{state.registers[reg]}"
  when 'rcv'
    val = value_of(args.first, state)
    if val.to_i == 0
      puts_cmd "[rcv] Not recovering, #{val} is 0!"
    else
      puts_cmd "[rcv] Recovering frequency #{state.last_sound}, #{val} != 0"
      ret = state.last_sound
    end
  when 'jgz'
    x = value_of(args.first, state)
    y = value_of(args.last, state)

    if x.to_i > 0
      next_i = i + y.to_i
      puts_cmd "[jgz] Jumping #{y} steps: #{x} > 0"
    else
      puts_cmd "[jgz] Not jumping: #{x} !> 0"
    end
  end

  [next_i, cmd, ret]
end

def part_1
  $debugging = false
  instructions = read_input
  state = State.new
  i = 0

  while i.between?(0, instructions.length - 1)
    i, _cmd, ret = handle_instruction(i, instructions, state)
    return ret if ret 
  end
end

p part_1
