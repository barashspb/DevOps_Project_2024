from pylint.checkers import BaseChecker

class StaticTest(BaseChecker):

    name = 'variable_non_Lyubov'
    priority = -1
    msgs = {
        'C9999': (
            "Variable Lyubov was found '%s' times",
            'pylint checker (static test) was used',
            'Variable Lyubov was found'
        ),
    }

    def visit_name(self, node):
        if node.name == "Lyubov":
            self.add_message('pylint checker (static test) was used', node=node, args=(node.name,))

def register(linter):
    linter.register_checker(StaticTest(linter))
