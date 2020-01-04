from __future__ import unicode_literals
from prompt_toolkit.filters import ViInsertMode
from prompt_toolkit.key_binding.key_processor import KeyPress
from prompt_toolkit.keys import Keys
from pygments.token import Token

from ptpython.layout import CompletionVisualisation

__all__ = (
    'configure',
)

def configure(repl):
    # Basic preferences.
    repl.vi_mode = True
    repl.enable_auto_suggest = True
    repl.confirm_exit = False

    # Keybindings.
    @repl.add_key_binding(Keys.ControlN)
    def _(event):
        event.cli.key_processor.feed(KeyPress(Keys.Down))
    @repl.add_key_binding(Keys.ControlP)
    def _(event):
        event.cli.key_processor.feed(KeyPress(Keys.Up))

