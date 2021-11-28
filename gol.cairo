%builtins output

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.serialize import serialize_array
from starkware.cairo.common.serialize import serialize_word
from starkware.cairo.common.registers import get_label_location

# L is PAD_MAP_LENGTH
func count_alive_cells(L : felt, p : felt*) -> (sum):
    let sum = [p - L - 1] + [p - L] + [p - L + 1] + [p - 1] + [p + 1] + [p + L - 1] + [p + L] + [p + L + 1]
    return (sum=sum)
end

# returns 1 if border cell, 0 otherwise
func is_border_cell(map_length : felt, x : felt, y : felt) -> (is_border):
    if x == 0:
        return (1)
    end
    if x == map_length - 1:
        return (1)
    end
    if y == 0:
        return (1)
    end
    if y == map_length - 1:
        return (1)
    end
    return (0)
end

# n is surrounding alive_cells, m is current cell.
func next_cell(n : felt, m : felt) -> (next):
    # equivalent to n != 2 && n != 3
    if n != 2:
        if n != 3:
            return (next=0)
        end
    end

    if n == 3:
        return (next=1)
    end
    # n == 2
    return (next=m)
end

# Writes a pattern to memory in the only way I know how.
# Is there a way to parse a str or something into this?
func populate_7x7_array(ptr : felt*):
    assert [ptr + 0] = 0
    assert [ptr + 1] = 0
    assert [ptr + 2] = 0
    assert [ptr + 3] = 0
    assert [ptr + 4] = 0
    assert [ptr + 5] = 0
    assert [ptr + 6] = 0

    assert [ptr + 7 + 0] = 0
    assert [ptr + 7 + 1] = 0
    assert [ptr + 7 + 2] = 0
    assert [ptr + 7 + 3] = 0
    assert [ptr + 7 + 4] = 0
    assert [ptr + 7 + 5] = 0
    assert [ptr + 7 + 6] = 0

    assert [ptr + 14 + 0] = 0
    assert [ptr + 14 + 1] = 0
    assert [ptr + 14 + 2] = 0
    assert [ptr + 14 + 3] = 0
    assert [ptr + 14 + 4] = 0
    assert [ptr + 14 + 5] = 0
    assert [ptr + 14 + 6] = 0

    assert [ptr + 21 + 0] = 0
    assert [ptr + 21 + 1] = 0
    assert [ptr + 21 + 2] = 1
    assert [ptr + 21 + 3] = 1
    assert [ptr + 21 + 4] = 1
    assert [ptr + 21 + 5] = 0
    assert [ptr + 21 + 6] = 0

    assert [ptr + 28 + 0] = 0
    assert [ptr + 28 + 1] = 0
    assert [ptr + 28 + 2] = 0
    assert [ptr + 28 + 3] = 0
    assert [ptr + 28 + 4] = 0
    assert [ptr + 28 + 5] = 0
    assert [ptr + 28 + 6] = 0

    assert [ptr + 35 + 0] = 0
    assert [ptr + 35 + 1] = 0
    assert [ptr + 35 + 2] = 0
    assert [ptr + 35 + 3] = 0
    assert [ptr + 35 + 4] = 0
    assert [ptr + 35 + 5] = 0
    assert [ptr + 35 + 6] = 0

    assert [ptr + 42 + 0] = 0
    assert [ptr + 42 + 1] = 0
    assert [ptr + 42 + 2] = 0
    assert [ptr + 42 + 3] = 0
    assert [ptr + 42 + 4] = 0
    assert [ptr + 42 + 5] = 0
    assert [ptr + 42 + 6] = 0
    return ()
end

# You should keep two counters:
# Counter of row x
# Counter of column y
# If x == 0 || x == PAD_MAP_LENGTH - 1 || y == 0 || y == PAD_MAP_LENGTH - 1
# write 0
# o.w. do the count_alive_cells cycle.
func gen_next_state(origin_ptr : felt*, x : felt, y : felt, map_length : felt, map_size : felt):
    let offset = x + y * map_length
    let next_map = origin_ptr + map_size
    let write_target = offset + next_map
    # cell is a border cell
    let (is_border) = is_border_cell(map_length, x, y)
    if is_border == 1:
        assert [write_target] = 0
    else:
        let (alive_count) = count_alive_cells(map_length, p=origin_ptr + offset)
        let (next_cell_value) = next_cell(n=alive_count, m=[origin_ptr + offset])
        assert [write_target] = next_cell_value
    end
    if x == (map_length - 1):
        if y != (map_length - 1):
            gen_next_state(origin_ptr, x=0, y=y + 1, map_length=map_length, map_size=map_size)
        end
        # # finish execution
    else:
        gen_next_state(origin_ptr, x=x + 1, y=y, map_length=map_length, map_size=map_size)
    end
    return ()
end

func gen_n_states(start_ptr : felt*, n : felt, map_length : felt, map_size : felt):
    gen_next_state(origin_ptr=start_ptr, x=0, y=0, map_length=map_length, map_size=map_size)
    if n != 0:
        gen_n_states(start_ptr + map_size, n=n - 1, map_length=map_length, map_size=map_size)
    end
    return ()
end

func main{output_ptr : felt*}():
    alloc_locals
    const MAP_LENGTH = 5
    const PAD_MAP_LENGTH = MAP_LENGTH + 2
    const MAP_SIZE = PAD_MAP_LENGTH * PAD_MAP_LENGTH
    const N = 1

    let (start_array) = alloc()

    populate_7x7_array(start_array)

    gen_n_states(start_ptr=start_array, n=1, map_length=PAD_MAP_LENGTH, map_size=MAP_SIZE)

    let last_state = start_array + (N * MAP_SIZE)
    # this just doesn't work
    let (callback_thing) = get_label_location(serialize_word)
    serialize_array(array=last_state, n_elms=MAP_SIZE, elm_size=1, callback=callback_thing)

    return ()
end
