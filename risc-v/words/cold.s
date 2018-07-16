#
#    Mecrisp-Quintus - A native code Forth implementation for RISC-V
#    Copyright (C) 2018  Matthias Koch
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

CODEWORD Flag_visible, "cold", COLD

  # This is the same as in quit, in order to prepare for whatever the user might want to do within "init".

  li sp, returnstackanfang
  li x4, datenstackanfang

  .ifdef initflash
  call initflash
  .endif

  li x6, base
  li x5, 10      # Base decimal
  sw x5, 0(x6)

  li x6, state
  li x5, 0       # Execute mode
  sw x5, 0(x6)

  li x6, konstantenfaltungszeiger
  li x5, 0       # Clear constant folding pointer
  sw x5, 0(x6)

  li x6, Pufferstand
  li x5, 0       # Set >IN to 0
  sw x5, 0(x6)

  li x6, current_source
  li x5, 0       # Empty TIB is source
  sw x5, 0(x6)
  li x5, Eingabepuffer
  sw x5, 4(x6)

  li x20, red|green|blue
  li x21, GPIO_OUTPUT_EN
  sw x20, 0(x21)

  la x17, XT_WARM
  j DO_EXECUTE
