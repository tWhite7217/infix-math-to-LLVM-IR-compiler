%{
#include <stdio.h>
#include <stdlib.h>
#include <set>
#include <map>
#include <vector>
#include <string>
#include <iostream>
#include <list>
#include <queue>
#include <algorithm>
#include <boost/range/irange.hpp>
#include <boost/range/adaptor/reversed.hpp>

int line_num = 0;
bool any_new_var_is_written = true;

typedef struct {
    int block_num;
    int block_line;
} InstructionID;

bool operator <(const InstructionID& x, const InstructionID& y) {
    return std::tie(x.block_num, x.block_line) < std::tie(y.block_num, y.block_line);
}

bool operator >(const InstructionID& x, const InstructionID& y) {
    return std::tie(x.block_num, x.block_line) > std::tie(y.block_num, y.block_line);
}

bool operator ==(const InstructionID& x, const InstructionID& y) {
    return std::tie(x.block_num, x.block_line) == std::tie(y.block_num, y.block_line);
}

InstructionID get_new_instruction_id();

typedef struct Instruction {
    int instruction_num;
    InstructionID id;
    int latency;
    int read_var_nums[2];
    int write_var_num;
    bool is_conditional;
    std::string text;
    std::vector<InstructionID> block_dependent_instructions;
    std::vector<InstructionID> block_dependences;
    std::vector<InstructionID> general_dependent_instructions;
    std::vector<InstructionID> general_dependences;

    Instruction() : instruction_num{line_num},
                    id{get_new_instruction_id()},
                    latency{0},
                    read_var_nums{-1, -1},
                    write_var_num{-1},
                    is_conditional{false},
                    text{""} {}
} Instruction;

bool operator <(const Instruction& x, const Instruction& y) {
    return x.id < y.id;
}

typedef struct {
    std::string name;
    bool is_user_defined;
} Variable;

std::vector<std::vector<Instruction>> basic_blocks;
std::vector<std::vector<Instruction>> reordered_basic_blocks;
std::vector<Variable> variables;
std::vector<Variable> tmp_variables;

InstructionID get_new_instruction_id() {
    return {int(basic_blocks.size() - 1), int(basic_blocks.back().size())};
}

void print_debug_info_if_necessary(char *yytext) {
	#ifdef DEBUG
		printf("token %s at line %d\n", yytext, lineNum);
	#endif
}

int get_variable_number(char *var_name, auto& var_vector) {
	for (auto i : boost::irange(var_vector.size())) {
		if (var_vector[i].name == var_name) {
			return i;
		}
	}
	return -1;
}

int add_variable_name(char *var_name, bool var_is_written, auto& var_vector) {
    Variable var = {var_name, !var_is_written};
	var_vector.push_back(var);
	return var_vector.size() - 1;
}

Instruction *get_current_instruction () {
    return &(basic_blocks.back().back());
}

void update_instruction_with_variable(int var_num) {
    Instruction *current_instruction = get_current_instruction();
    if (current_instruction->is_conditional) {
        current_instruction->read_var_nums[0] = var_num;
    } else if (current_instruction->write_var_num == -1) {
        current_instruction->write_var_num = var_num;
    } else if (current_instruction->read_var_nums[0] == -1) {
        current_instruction->read_var_nums[0] = var_num;
    } else {
        current_instruction->read_var_nums[1] = var_num;
    }
}

void update_instruction_latency(int added_latency) {
    Instruction *current_instruction = get_current_instruction();
    current_instruction->latency += added_latency;
}

int has_read_after_write(Instruction *earlier_instruction, Instruction *later_instruction) {
    return  (earlier_instruction->write_var_num != -1) &&
            ((later_instruction->read_var_nums[0] == earlier_instruction->write_var_num) ||
            (later_instruction->read_var_nums[1] == earlier_instruction->write_var_num));
}

int has_write_after_write(Instruction *earlier_instruction, Instruction *later_instruction) {
    return  ((later_instruction->write_var_num != -1) &&
            (later_instruction->write_var_num == earlier_instruction->write_var_num));
}

int has_write_after_read(Instruction *earlier_instruction, Instruction *later_instruction) {
    return (later_instruction->write_var_num != -1) &&
    ((later_instruction->write_var_num == earlier_instruction->read_var_nums[0]) ||
    (later_instruction->write_var_num == earlier_instruction->read_var_nums[1]));
}

void indicate_dependencies_exist (Instruction *earlier_instruction, Instruction *later_instruction, int earlier_block_num, int later_block_num) {
    earlier_instruction->general_dependent_instructions.push_back(later_instruction->id);
    later_instruction->general_dependences.push_back(earlier_instruction->id);

    if (earlier_block_num == later_block_num) {
        earlier_instruction->block_dependent_instructions.push_back(later_instruction->id);
        later_instruction->block_dependences.push_back(earlier_instruction->id);
    }
}

void update_dependency(Instruction *earlier_instruction, Instruction *later_instruction, int earlier_block_num, int later_block_num) {
    if (has_read_after_write(earlier_instruction, later_instruction) ||
        has_write_after_write(earlier_instruction, later_instruction) ||
        has_write_after_read(earlier_instruction, later_instruction)) {
            indicate_dependencies_exist(earlier_instruction, later_instruction, earlier_block_num, later_block_num);
        }
}

void update_all_dependencies() {
    auto num_blocks = basic_blocks.size();
    for (auto i : boost::irange(num_blocks)) {
        auto i_block_size = basic_blocks[i].size();
        for (auto j : boost::irange(i_block_size)) {
            Instruction *earlier_instruction = &basic_blocks[i][j];
            for (auto k : boost::irange(i, num_blocks)) {
                auto k_block_size = basic_blocks[k].size();
                auto l_range_start = (i==k ? j+1 : 0);
                auto l_range = boost::irange(l_range_start, k_block_size);
                for (auto l : l_range) {
                    update_dependency(earlier_instruction, &basic_blocks[k][l], i, k);
                }
            }
        }
    }
}

Instruction *get_instruction_pointer_from_id(InstructionID id) {
    return &basic_blocks[id.block_num][id.block_line];
}

void print_basic_block(int block_num) {
    auto block = basic_blocks[block_num];
    for (auto instruction : block) {
        std::cout << instruction.text << "   ";
        printf("instr: %d  block: %d  block_line: %d  latency: %d \n",
            instruction.instruction_num,
            instruction.id.block_num,
            instruction.id.block_line,
            instruction.latency
        );
    }
}

void add_to_instruction_text(std::string yytext) {
    get_current_instruction()->text += yytext;
}

bool instruction_depends_on_other_instruction(Instruction instruction, Instruction other_instruction) {
    auto dependences = instruction.general_dependences;
    return std::find(dependences.begin(), dependences.end(), other_instruction.id) != dependences.end();
}

void update_running_instructions(auto& running_instructions) {
    std::vector<Instruction> instructions_to_remove;
    for (auto& [running_instruction, instruction_cycles_left] : running_instructions) {
        instruction_cycles_left--;
        if (instruction_cycles_left == 0) {
            instructions_to_remove.push_back(running_instruction);
        }
    }
    for (auto instruction : instructions_to_remove) {
        running_instructions.erase(instruction);
    }
}

bool next_instruction_is_ready(auto instruction_queue, auto running_instructions) {
    Instruction next_instruction = instruction_queue.front();
    for (auto [running_instruction, _] : running_instructions) {
        if (instruction_depends_on_other_instruction(next_instruction, running_instruction)) {
            return false;
        }
    }
    return true;
}

void run_next_instruction(auto& instruction_queue, auto& running_instructions) {
    Instruction next_instruction = instruction_queue.front();
    running_instructions.emplace(next_instruction, next_instruction.latency);
    instruction_queue.pop();
}

int max_running_time_left(auto running_instructions) {
    int max_cycles_left = 0;
    for (auto [_, instruction_cycles_left] : running_instructions) {
        max_cycles_left = std::max(max_cycles_left, instruction_cycles_left);
    }
    return max_cycles_left;
}

int get_latency(auto blocks) {
    int clock_cycle = 0;
    std::map<Instruction, int> running_instructions;
    std::queue<Instruction> instruction_queue;
    for (auto block : blocks) {
        for (auto instruction : block) {
            if (instruction.latency != 0) {
                instruction_queue.push(instruction);
            }
        }
    }
    while (!instruction_queue.empty()) {
        if (next_instruction_is_ready(instruction_queue, running_instructions)) {
            run_next_instruction(instruction_queue, running_instructions);
        }

        update_running_instructions(running_instructions);

        clock_cycle++;
    }
    clock_cycle += max_running_time_left(running_instructions);
    return clock_cycle;
}

%}

%%
[ ]+ {
        add_to_instruction_text(std::string(yytext));
    }

[\t\n]+ {}

"BB"[0-9]+":" {
    if (!basic_blocks.empty()) {
        basic_blocks.back().pop_back();
    } 
    basic_blocks.emplace_back();
    basic_blocks.back().emplace_back();
}

[;]+ {
        add_to_instruction_text(std::string(yytext));
		line_num++;
        any_new_var_is_written = true;
        basic_blocks.back().emplace_back();
    }

"if(" {
        add_to_instruction_text(std::string(yytext));
        update_instruction_latency(2);
        get_current_instruction()->is_conditional = true;
    }

")"[ \t]*"{"[ \t\n]*"goto"[ \t\n]*"BB"[0-9]+[ \t\n]*";"[ \t\n]*"}"[ \t\n]*"else"[ \t]*"{"[ \t\n]*"goto"[ \t\n]*"BB"[0-9]+[ \t\n]*";"[ \t\n]*"}" {
        add_to_instruction_text(")");
		line_num++;
        basic_blocks.back().emplace_back();
    }

"goto"[ \t\n]*"BB"[0-9]+[ \t\n]*";" {

}

"**" {
	print_debug_info_if_necessary(yytext);
    update_instruction_latency(8);
    add_to_instruction_text(std::string(yytext));
	}

"+" {
	print_debug_info_if_necessary(yytext);
    update_instruction_latency(1);
    add_to_instruction_text(std::string(yytext));
	}

"-" {
	print_debug_info_if_necessary(yytext);
    update_instruction_latency(1);
    add_to_instruction_text(std::string(yytext));
	}

"*" {
	print_debug_info_if_necessary(yytext);
    update_instruction_latency(4);
    add_to_instruction_text(std::string(yytext));
	}

"/" {
	print_debug_info_if_necessary(yytext);
    update_instruction_latency(4);
    add_to_instruction_text(std::string(yytext));
	}

"!" {
	print_debug_info_if_necessary(yytext);
    add_to_instruction_text(std::string(yytext));
	}

"=" {
	print_debug_info_if_necessary(yytext);
    update_instruction_latency(2);
    any_new_var_is_written = false;
    add_to_instruction_text(std::string(yytext));
	}

[0-9]+ {
	print_debug_info_if_necessary(yytext);
    add_to_instruction_text(std::string(yytext));
	}

"tmp"[0-9]+ {
	print_debug_info_if_necessary(yytext);
	int var_num = get_variable_number(yytext, tmp_variables);
	if (var_num == -1) {
		var_num = add_variable_name(yytext, any_new_var_is_written, tmp_variables);
	}
    update_instruction_with_variable(var_num);
    add_to_instruction_text(std::string(yytext));
	}

[A-z][A-z0-9_]* {
	print_debug_info_if_necessary(yytext);
	int var_num = get_variable_number(yytext, variables);
	if (var_num == -1) {
		var_num = add_variable_name(yytext, any_new_var_is_written, variables);
	}
    update_instruction_with_variable(var_num);
    add_to_instruction_text(std::string(yytext));
	}

%%
int yywrap() { /* need this to avoid link problem */
	return 1;
}

int main(int argc, char** argv) {
	if (argc < 2) {
		return 0;
	}
	yyin = fopen(argv[1], "r");
	yylex();
    basic_blocks.back().pop_back();
    // print_basic_block(0);
    update_all_dependencies();
    int latency = get_latency(basic_blocks);
    std::cout << latency << "\n";
	return 0;
}
